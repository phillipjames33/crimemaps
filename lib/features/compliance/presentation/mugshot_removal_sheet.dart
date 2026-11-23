import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/compliance_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/compliance_models.dart';
import 'compliance_controller.dart';

/// 100% FREE Record Removal & Expungement Request Modal Sheet.
///
/// Under California/Georgia public arrest record transparency laws and Crime Maps
/// core ethics, removal and expungement requests are ALWAYS 100% free of charge
/// and never gated behind paywalls or subscriptions.
class MugshotRemovalSheet extends ConsumerStatefulWidget {
  final String incidentId;
  final String? offenderName;
  final VoidCallback? onRedacted;

  const MugshotRemovalSheet({
    super.key,
    required this.incidentId,
    this.offenderName,
    this.onRedacted,
  });

  @override
  ConsumerState<MugshotRemovalSheet> createState() =>
      _MugshotRemovalSheetState();
}

class _MugshotRemovalSheetState extends ConsumerState<MugshotRemovalSheet> {
  static const Uuid _uuid = Uuid();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  RemovalReason _selectedReason = RemovalReason.expunged;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _caseNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    final MugshotRemovalRequest request = MugshotRemovalRequest(
      id: 'rem-${_uuid.v4().substring(0, 8)}',
      incidentId: widget.incidentId,
      requesterName: _nameController.text.trim(),
      requesterEmail: _emailController.text.trim(),
      reason: _selectedReason,
      caseNumber: _caseNumberController.text.trim().isEmpty
          ? null
          : _caseNumberController.text.trim(),
      additionalNotes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      submittedAt: DateTime.now().toUtc(),
      status: 'redacted_pending_verification',
    );

    try {
      await ref
          .read(complianceControllerProvider.notifier)
          .submitMugshotRemoval(request);

      if (mounted) {
        widget.onRedacted?.call();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppTheme.accentEmerald,
            content: Text(
              'Removal request submitted. Booking details have been redacted pending verification.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentCrimson,
            content: Text('Submission failed: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _formatReason(RemovalReason reason) {
    switch (reason) {
      case RemovalReason.expunged:
        return 'Official Court Expungement Order';
      case RemovalReason.dismissedOrAcquitted:
        return 'Charges Dismissed or Acquitted';
      case RemovalReason.sealedRecord:
        return 'Sealed or Juvenile Record';
      case RemovalReason.mistakenIdentity:
        return 'Mistaken Identity / False Booking';
      case RemovalReason.privacyRequest:
        return 'Privacy / Exigent Safety Request';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentEmerald.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user,
                        color: AppTheme.accentEmerald, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Record Removal & Expungement',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Submit court documentation or redaction request',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mandatory 100% FREE Banner
              Container(
                key: const Key('removal_free_banner'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentEmerald, width: 1.2),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.check_circle,
                        color: AppTheme.accentEmerald, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '100% Free — Crime Maps never charges to remove or expunge arrest records',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Presumed Innocent Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info_outline,
                        color: AppTheme.accentAmber, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ComplianceConstants.presumedInnocentDisclaimer,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (widget.offenderName != null) ...<Widget>[
                Text(
                  'Record Subject: ${widget.offenderName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Requester Name
              TextFormField(
                key: const Key('removal_name_field'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Requester Full Legal Name',
                  hintText: 'e.g., Marcus Vance',
                ),
                validator: (String? val) {
                  if (val == null || val.trim().length < 2) {
                    return 'Please enter your full legal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Requester Email
              TextFormField(
                key: const Key('removal_email_field'),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Contact Email Address',
                  hintText: 'e.g., marcus@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String? val) {
                  if (val == null || !val.contains('@') || !val.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Reason Dropdown
              DropdownButtonFormField<RemovalReason>(
                key: const Key('removal_reason_dropdown'),
                initialValue: _selectedReason,
                decoration: const InputDecoration(
                  labelText: 'Legal Reason for Removal / Redaction',
                ),
                dropdownColor: AppTheme.surfaceElevated,
                items: RemovalReason.values.map((RemovalReason reason) {
                  return DropdownMenuItem<RemovalReason>(
                    value: reason,
                    child: Text(
                      _formatReason(reason),
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (RemovalReason? val) {
                  if (val != null) {
                    setState(() => _selectedReason = val);
                  }
                },
              ),
              const SizedBox(height: 10),

              // Case Number (Optional)
              TextFormField(
                key: const Key('removal_case_number_field'),
                controller: _caseNumberController,
                decoration: const InputDecoration(
                  labelText: 'Court Docket / Case Number (Optional)',
                  hintText: 'e.g., 2026-CR-08914',
                ),
              ),
              const SizedBox(height: 10),

              // Additional Notes
              TextFormField(
                key: const Key('removal_notes_field'),
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Details / Verification Notes (Optional)',
                  hintText:
                      'Provide dismissal date, court jurisdiction, or case disposition...',
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  key: const Key('removal_submit_button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentEmerald,
                    foregroundColor: const Color(0xFF06131F),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF06131F),
                          ),
                        )
                      : const Icon(Icons.send),
                  label: const Text(
                    'Submit 100% Free Removal Request',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onPressed: _isSubmitting ? null : _submitRequest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
