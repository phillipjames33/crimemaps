import 'package:flutter/material.dart';

import '../../../../core/config/compliance_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/territory_model.dart';
import 'territory_submission_dialog.dart';

/// Read-only historical territory context sheet.
///
/// Strictly enforces displaying [ComplianceConstants.historicalTerritoryLabel]
/// (`"Historical / Publicly Documented Neighborhood Context"`), `citationDate`,
/// and `sourceReference`, and routes community corrections through
/// [TerritorySubmissionDialog] to the moderated `territory_submissions` queue.
class TerritoryContextSheet extends StatelessWidget {
  const TerritoryContextSheet({
    super.key,
    required this.territory,
    this.onSubmitCorrection,
  });

  final Territory territory;
  final Future<void> Function(TerritorySubmission submission)?
      onSubmitCorrection;

  static Future<void> show(
    BuildContext context, {
    required Territory territory,
    Future<void> Function(TerritorySubmission submission)? onSubmitCorrection,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        return TerritoryContextSheet(
          territory: territory,
          onSubmitCorrection: onSubmitCorrection,
        );
      },
    );
  }

  Color _parseHexColor(String hex) {
    final sanitized = hex.replaceFirst('#', '').trim();
    if (sanitized.length == 6) {
      final parsed = int.tryParse('FF$sanitized', radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return AppTheme.accentAmber;
  }

  Future<void> _openSubmissionDialog(BuildContext context) async {
    final submitted = await TerritorySubmissionDialog.show(
      context,
      existingTerritory: territory,
      onSubmit: onSubmitCorrection,
    );
    if (submitted == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Correction submitted to the territory_submissions moderation queue.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _parseHexColor(territory.colorHex);
    const mandatoryLabel = ComplianceConstants.historicalTerritoryLabel;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Mandatory Historical Context compliance banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.history_edu_rounded,
                    size: 18,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mandatoryLabel,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: <Widget>[
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    territory.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _CitationRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Citation Date',
                    value: territory.citationDate,
                  ),
                  const SizedBox(height: 10),
                  _CitationRow(
                    icon: Icons.menu_book_rounded,
                    label: 'Source Reference',
                    value: territory.sourceReference,
                  ),
                  if (territory.historicalNotes != null &&
                      territory.historicalNotes!.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 10),
                    _CitationRow(
                      icon: Icons.notes_rounded,
                      label: 'Historical Notes',
                      value: territory.historicalNotes!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openSubmissionDialog(context),
                icon: const Icon(Icons.edit_note_rounded, size: 19),
                label: const Text('Suggest Historical Correction'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentCyan,
                  side: BorderSide(
                    color: AppTheme.accentCyan.withValues(alpha: 0.55),
                  ),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Community suggestions are queued for moderation and never auto-published.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitationRow extends StatelessWidget {
  const _CitationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: AppTheme.accentCyan),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
