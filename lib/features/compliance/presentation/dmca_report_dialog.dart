import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/compliance_models.dart';
import 'compliance_controller.dart';

/// One-click DMCA Safe Harbor Copyright Infringement Dialog.
///
/// Under 17 U.S.C. § 512(c), submitting this notice immediately transitions
/// the track status to `flagged_dmca` and soft-hides it from public Geo-Radio playback.
class DmcaReportDialog extends ConsumerStatefulWidget {
  final String trackId;
  final String trackTitle;
  final VoidCallback? onFlagged;

  const DmcaReportDialog({
    super.key,
    required this.trackId,
    required this.trackTitle,
    this.onFlagged,
  });

  @override
  ConsumerState<DmcaReportDialog> createState() => _DmcaReportDialogState();
}

class _DmcaReportDialogState extends ConsumerState<DmcaReportDialog> {
  static const Uuid _uuid = Uuid();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  bool _goodFaith = false;
  bool _perjury = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _signatureController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _goodFaith &&
      _perjury &&
      _signatureController.text.trim().length >= 2 &&
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().contains('@') &&
      _descriptionController.text.trim().isNotEmpty &&
      !_isSubmitting;

  Future<void> _submitClaim() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    final DmcaClaim claim = DmcaClaim(
      id: 'dmca-${_uuid.v4().substring(0, 8)}',
      trackId: widget.trackId,
      trackTitle: widget.trackTitle,
      claimantName: _nameController.text.trim(),
      claimantEmail: _emailController.text.trim(),
      copyrightedWorkDescription: _descriptionController.text.trim(),
      goodFaithBeliefConfirmed: _goodFaith,
      perjuryStatementConfirmed: _perjury,
      electronicSignature: _signatureController.text.trim(),
      submittedAt: DateTime.now().toUtc(),
      status: 'track_soft_hidden',
    );

    try {
      await ref
          .read(complianceControllerProvider.notifier)
          .submitDmcaClaim(claim);

      if (mounted) {
        widget.onFlagged?.call();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentCrimson,
            content: Text(
              'DMCA takedown notice filed. "${widget.trackTitle}" has been soft-hidden from broadcast rotation.',
              style: const TextStyle(fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      title: const Row(
        children: <Widget>[
          Icon(Icons.copyright, color: AppTheme.accentCrimson, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Report Copyright Infringement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentCrimson.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.accentCrimson.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'Notice: Filing a DMCA takedown immediately soft-hides "${widget.trackTitle}" from public playback under 17 U.S.C. § 512(c).',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Claimant Name
              TextFormField(
                key: const Key('dmca_claimant_name_field'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Copyright Owner / Agent Name',
                  hintText: 'e.g., Warner Chappell Music / John Doe',
                ),
              ),
              const SizedBox(height: 10),

              // Claimant Email
              TextFormField(
                key: const Key('dmca_claimant_email_field'),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Claimant Official Email',
                  hintText: 'e.g., copyright@label.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                key: const Key('dmca_work_description_field'),
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description of Infringed Work & Original Link',
                  hintText: 'Specify original song, ISRC, or copyright registration number...',
                ),
              ),
              const SizedBox(height: 12),

              // Good Faith Checkbox
              CheckboxListTile(
                key: const Key('dmca_good_faith_checkbox'),
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.accentCrimson,
                title: const Text(
                  'I have a good faith belief that use of the material is not authorized by the copyright owner, its agent, or the law.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                value: _goodFaith,
                onChanged: (bool? val) {
                  setState(() => _goodFaith = val ?? false);
                },
              ),

              // Perjury Checkbox
              CheckboxListTile(
                key: const Key('dmca_perjury_checkbox'),
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.accentCrimson,
                title: const Text(
                  'I state under penalty of perjury that the information in this notice is accurate and I am authorized to act on behalf of the owner.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                value: _perjury,
                onChanged: (bool? val) {
                  setState(() => _perjury = val ?? false);
                },
              ),
              const SizedBox(height: 10),

              // Electronic Signature
              TextFormField(
                key: const Key('dmca_signature_field'),
                controller: _signatureController,
                decoration: const InputDecoration(
                  labelText: 'Typed Electronic Signature',
                  hintText: 'Type your full legal name',
                  helperText: 'Required to execute statutory takedown notice',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('dmca_submit_button'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentCrimson,
            foregroundColor: Colors.white,
          ),
          onPressed: _canSubmit ? _submitClaim : null,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Submit DMCA Takedown'),
        ),
      ],
    );
  }
}
