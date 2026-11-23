/**
 * Firestore trigger handler (`onHighSeverityIncident`).
 *
 * Dispatches FCM push notifications to `geo_{prefix}`, `city_{slug}`, and
 * `state_{code}` topics whenever a `high` or `critical` severity incident is
 * created.
 */
import type { Messaging, TopicMessage } from 'firebase-admin/messaging';
import { HIGH_SEVERITY_LEVELS, IncidentSeverity } from '../types';
import { geohashTopicPrefixes, slugify } from '../utils/geohash';
import { asRecord, readString } from '../utils/json';
import { LoggerLike } from './ingestCrimeFeeds';

export interface MessagingLike {
  send(message: TopicMessage): Promise<string>;
}

export interface IncidentTopicInput {
  geohash: string;
  citySlug: string;
  stateCode: string;
}

/** Builds deduplicated FCM topic names matching the Flutter `FcmTopicService`. */
export function buildAlertTopics(input: IncidentTopicInput): string[] {
  const topics = new Set<string>();
  const cleanGeohash = input.geohash.trim().toLowerCase();
  for (const prefix of geohashTopicPrefixes(cleanGeohash)) {
    topics.add(`geo_${prefix}`);
  }
  const cleanCity = slugify(input.citySlug);
  if (cleanCity.length > 0) {
    topics.add(`city_${cleanCity}`);
  }
  const cleanState = input.stateCode.trim().toLowerCase().replace(/[^a-z0-9]/g, '');
  if (cleanState.length > 0) {
    topics.add(`state_${cleanState}`);
  }
  return Array.from(topics);
}

export function isHighSeverity(severity: unknown): severity is IncidentSeverity {
  return (
    typeof severity === 'string' &&
    (HIGH_SEVERITY_LEVELS as readonly string[]).includes(severity)
  );
}

export interface HighSeverityIncidentDeps {
  incidentId: string;
  data: Record<string, unknown> | undefined;
  messaging: Pick<Messaging, 'send'> | MessagingLike;
  logger?: LoggerLike;
}

export interface HighSeverityIncidentResult {
  dispatched: boolean;
  reason?: string;
  topics: string[];
  sentCount: number;
  failedTopics: string[];
}

export async function runHighSeverityIncident(
  deps: HighSeverityIncidentDeps,
): Promise<HighSeverityIncidentResult> {
  const log = deps.logger ?? console;
  const { incidentId, data } = deps;

  if (data === undefined) {
    return { dispatched: false, reason: 'missing_data', topics: [], sentCount: 0, failedTopics: [] };
  }

  const severity = data['severity'];
  if (!isHighSeverity(severity)) {
    return {
      dispatched: false,
      reason: `severity_${String(severity)}`,
      topics: [],
      sentCount: 0,
      failedTopics: [],
    };
  }

  const geo = asRecord(data['geo']);
  const geohash = (geo !== null ? readString(geo, 'geohash') : null) ?? '';
  const citySlug = readString(data, 'citySlug') ?? '';
  const cityName = readString(data, 'cityName') ?? 'Nearby Area';
  const stateCode = readString(data, 'stateCode') ?? '';
  const title = readString(data, 'title') ?? 'Public Safety Incident';
  const address = readString(data, 'address') ?? cityName;
  const category = readString(data, 'category') ?? 'other';

  const topics = buildAlertTopics({ geohash, citySlug, stateCode });
  if (topics.length === 0) {
    log.warn('High-severity incident had no valid FCM alert topics', { incidentId });
    return { dispatched: false, reason: 'no_topics', topics: [], sentCount: 0, failedTopics: [] };
  }

  const severityLabel = severity === 'critical' ? 'Critical Public Safety Alert' : 'High-Severity Safety Alert';
  const notificationTitle = `${severityLabel} — ${cityName}${stateCode ? `, ${stateCode.toUpperCase()}` : ''}`;
  const notificationBody = `${title} reported near ${address}. Tap for public safety details.`;

  const payloadData: Record<string, string> = {
    incidentId,
    severity,
    category,
    citySlug,
    stateCode: stateCode.toUpperCase(),
    geohash,
  };

  const results = await Promise.allSettled(
    topics.map((topic) =>
      deps.messaging.send({
        topic,
        notification: {
          title: notificationTitle,
          body: notificationBody,
        },
        data: payloadData,
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
            },
          },
        },
      }),
    ),
  );

  let sentCount = 0;
  const failedTopics: string[] = [];
  results.forEach((res, idx) => {
    if (res.status === 'fulfilled') {
      sentCount += 1;
    } else {
      failedTopics.push(topics[idx]);
      log.error('Failed to send FCM topic alert', {
        incidentId,
        topic: topics[idx],
        error: res.reason instanceof Error ? res.reason.message : String(res.reason),
      });
    }
  });

  log.info('onHighSeverityIncident dispatched', {
    incidentId,
    severity,
    topics,
    sentCount,
    failedTopics,
  });

  return {
    dispatched: sentCount > 0,
    topics,
    sentCount,
    failedTopics,
  };
}
