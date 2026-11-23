/**
 * Callable Cloud Function handler (`submitMugshotRemoval`).
 *
 * 100% FREE record removal / expungement flow — never gated behind any
 * paywall, subscription, or account requirement. Logs `removal_requests` and
 * immediately redacts `allegedOffender` fields on `incidents/{incidentId}`
 * pending verification.
 */
import { HttpsError } from 'firebase-functions/v2/https';
import {
  AllegedOffender,
  MugshotRemovalInput,
  MugshotRemovalRequest,
  MugshotRemovalResult,
  REMOVAL_REASONS,
  RemovalReason,
} from '../types';
import {
  PRESUMED_INNOCENT_DISCLAIMER,
  redactOffender,
  REMOVAL_REQUEST_FEE,
} from '../utils/compliance';
import { asRecord, readString } from '../utils/json';
import { LoggerLike } from './ingestCrimeFeeds';

function isRemovalReason(value: unknown): value is RemovalReason {
  return typeof value === 'string' && (REMOVAL_REASONS as readonly string[]).includes(value);
}

export function validateMugshotRemovalInput(raw: unknown): MugshotRemovalInput {
  const obj = asRecord(raw);
  if (obj === null) {
    throw new HttpsError('invalid-argument', 'Request payload must be an object.');
  }

  const incidentId = readString(obj, 'incidentId');
  const requesterName = readString(obj, 'requesterName');
  const requesterEmail = readString(obj, 'requesterEmail') ?? '';
  const reasonRaw = obj['reason'];

  if (incidentId === null) {
    throw new HttpsError('invalid-argument', 'incidentId is required.');
  }
  if (requesterName === null) {
    throw new HttpsError('invalid-argument', 'requesterName is required.');
  }
  if (!isRemovalReason(reasonRaw)) {
    throw new HttpsError(
      'invalid-argument',
      `reason must be one of: ${REMOVAL_REASONS.join(', ')}.`,
    );
  }
  if (requesterEmail.length > 0 && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(requesterEmail)) {
    throw new HttpsError('invalid-argument', 'requesterEmail is not a valid email address.');
  }

  const caseNumber = readString(obj, 'caseNumber');
  const additionalNotes = readString(obj, 'additionalNotes');

  return {
    incidentId,
    requesterName: requesterName.slice(0, 200),
    requesterEmail: requesterEmail.slice(0, 320),
    reason: reasonRaw,
    caseNumber: caseNumber !== null ? caseNumber.slice(0, 100) : null,
    additionalNotes: additionalNotes !== null ? additionalNotes.slice(0, 2000) : null,
  };
}

function toOffenderRecord(raw: unknown, fallbackAgency: string, now: Date): AllegedOffender | null {
  const obj = asRecord(raw);
  if (obj === null) return null;

  const bookingDateRaw = obj['bookingDate'];
  let bookingDate = now;
  if (bookingDateRaw instanceof Date) {
    bookingDate = bookingDateRaw;
  } else if (
    typeof bookingDateRaw === 'object' &&
    bookingDateRaw !== null &&
    'toDate' in bookingDateRaw &&
    typeof (bookingDateRaw as { toDate: unknown }).toDate === 'function'
  ) {
    bookingDate = (bookingDateRaw as { toDate: () => Date }).toDate();
  } else if (typeof bookingDateRaw === 'string') {
    const parsed = new Date(bookingDateRaw);
    if (!Number.isNaN(parsed.getTime())) bookingDate = parsed;
  }

  const expiresRaw = obj['expiresAt'];
  let expiresAt = bookingDate;
  if (expiresRaw instanceof Date) {
    expiresAt = expiresRaw;
  } else if (
    typeof expiresRaw === 'object' &&
    expiresRaw !== null &&
    'toDate' in expiresRaw &&
    typeof (expiresRaw as { toDate: unknown }).toDate === 'function'
  ) {
    expiresAt = (expiresRaw as { toDate: () => Date }).toDate();
  }

  return {
    name: readString(obj, 'name') ?? '',
    bookingPhotoUrl: readString(obj, 'bookingPhotoUrl'),
    charges: Array.isArray(obj['charges'])
      ? obj['charges'].filter((c): c is string => typeof c === 'string')
      : [],
    bookingDate,
    sourceAgency: readString(obj, 'sourceAgency') ?? fallbackAgency,
    disclaimer: readString(obj, 'disclaimer') ?? PRESUMED_INNOCENT_DISCLAIMER,
    expiresAt,
    redacted: obj['redacted'] === true,
    redactionRequestId: readString(obj, 'redactionRequestId'),
    redactedAt: null,
  };
}

export interface SubmitMugshotRemovalDeps {
  db: FirebaseFirestore.Firestore;
  data: unknown;
  requesterUid: string | null;
  now?: Date;
  logger?: LoggerLike;
}

export async function runSubmitMugshotRemoval(
  deps: SubmitMugshotRemovalDeps,
): Promise<MugshotRemovalResult> {
  const now = deps.now ?? new Date();
  const log = deps.logger ?? console;
  const input = validateMugshotRemovalInput(deps.data);

  const incidentRef = deps.db.collection('incidents').doc(input.incidentId);
  const requestRef = deps.db.collection('removal_requests').doc();
  const requestId = requestRef.id;

  const result = await deps.db.runTransaction(async (tx) => {
    const incidentSnap = await tx.get(incidentRef);
    if (!incidentSnap.exists) {
      throw new HttpsError('not-found', `Incident "${input.incidentId}" was not found.`);
    }

    const incidentData = asRecord(incidentSnap.data()) ?? {};
    const sourceAgency = readString(incidentData, 'sourceAgency') ?? 'Public Record';
    const existingOffender = toOffenderRecord(
      incidentData['allegedOffender'],
      sourceAgency,
      now,
    );

    const requestRecord: MugshotRemovalRequest = {
      id: requestId,
      incidentId: input.incidentId,
      requesterName: input.requesterName,
      requesterEmail: input.requesterEmail,
      reason: input.reason,
      caseNumber: input.caseNumber ?? null,
      additionalNotes: input.additionalNotes ?? null,
      submittedAt: now,
      status: 'redacted_pending_verification',
      requesterUid: deps.requesterUid,
      feeCharged: REMOVAL_REQUEST_FEE,
    };

    tx.set(requestRef, requestRecord);

    if (existingOffender !== null) {
      const redactedOffender = redactOffender(existingOffender, requestId, now);
      tx.update(incidentRef, {
        allegedOffender: redactedOffender,
      });
    }

    return {
      requestId,
      incidentId: input.incidentId,
      status: 'redacted_pending_verification' as const,
      redacted: existingOffender !== null,
      feeCharged: REMOVAL_REQUEST_FEE,
    };
  });

  log.info('submitMugshotRemoval processed free redaction request', {
    requestId: result.requestId,
    incidentId: result.incidentId,
    redacted: result.redacted,
    feeCharged: result.feeCharged,
  });

  return result;
}
