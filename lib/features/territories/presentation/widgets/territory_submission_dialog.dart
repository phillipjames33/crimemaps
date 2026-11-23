import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/territory_model.dart';
import '../territory_providers.dart';

/// Community suggestion & historical correction dialog.
///
/// Submits corrections strictly to the `territory_submissions` moderation queue
/// (`moderationStatus: 'pending_review'`) and never directly alters live
/// `territories` overlays.
class TerritorySubmissionDialog extends ConsumerStatefulWidget {
  const TerritorySubmissionDialog({
    super.key,
    this.existingTerritory,
    this.defaultCitySlug = 'atlanta',
    this.defaultStateCode = 'GA',
    this.submittedByUserId = 'community-contributor',
    this.onSubmit,
  });

  final Territory? existingTerritory;
  final String defaultCitySlug;
  final String defaultStateCode;
  final String submittedByUserId;
  final Future<void> Function(TerritorySubmission submission)? onSubmit;

  static Future<bool?> show(
    BuildContext context, {
    Territory? existingTerritory,
    String defaultCitySlug = 'atlanta',
    String defaultStateCode = 'GA',
    Future<void> Function(TerritorySubmission submission)? onSubmit,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => TerritorySubmissionDialog(
        existingTerritory: existingTerritory,
        defaultCitySlug: existingTerritory?.citySlug ?? defaultCitySlug,
        defaultStateCode: existingTerritory?.stateCode ?? defaultStateCode,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  ConsumerState<TerritorySubmissionDialog> createState() =>
      _TerritorySubmissionDialogState();
}

class _TerritorySubmissionDialogState
    extends ConsumerState<TerritorySubmissionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _citationController;
  late final TextEditingController _notesController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingTerritory?.name ?? '',
    );
    _citationController = TextEditingController(
      text: widget.existingTerritory?.sourceReference ?? '',
    );
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _citationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final submission = TerritorySubmission(
        id: const Uuid().v4(),
        territoryId: widget.existingTerritory?.id,
        proposedName: _nameController.text.trim(),
        citySlug: widget.existingTerritory?.citySlug ?? widget.defaultCitySlug,
        stateCode: widget.existingTerritory?.stateCode ?? widget.defaultStateCode,
        sourceCitation: _citationController.text.trim(),
        notes: _notesController.text.trim(),
        submittedByUserId: widget.submittedByUserId,
        submittedAt: DateTime.now().toUtc(),
        moderationStatus: 'pending_review',
      );

      if (widget.onSubmit != null) {
        await widget.onSubmit!(submission);
      } else {
        await ref
            .read(territoryRepositoryProvider)
            .submitCorrection(submission);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to submit correction right now. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      title: const Row(
        children: <Widget>[
          Icon(
            Icons.edit_location_alt_outlined,
            color: AppTheme.accentCyan,
            size: 22,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Suggest Historical Correction',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
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
                  color: AppTheme.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.accentCyan.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'All submissions enter the moderated territory_submissions queue for citation review and are never auto-published.',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Historical Sector / Neighborhood Name',
                  hintText: 'e.g., Historic Westside Corridor',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a sector or neighborhood name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _citationController,
                decoration: const InputDecoration(
                  labelText: 'Public Source Citation',
                  hintText: 'News archive, public briefing, or court filing',
                ),
                maxLines: 2,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A public source citation is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Correction Details / Context Notes',
                  hintText: 'Describe boundary or archival citation updates',
                ),
                maxLines: 3,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe your suggested correction';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isSubmitting ? null : _handleSubmit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_rounded, size: 16),
          label: const Text('Submit for Moderation'),
        ),
      ],
    );
  }
}
