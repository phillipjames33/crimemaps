import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/config/compliance_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../geo_radio/domain/track_model.dart';
import '../../monetization/presentation/artist_boost_sheet.dart';
import '../domain/track_upload_request.dart';
import 'creator_portal_controller.dart';

/// Indie Artist Creator Portal Screen.
/// Allows independent musicians to upload hyper-local audio tracks, certify
/// 100% ownership under strict legal warranties, and boost tracks to specific
/// cities or ZIP codes for Geo-Radio broadcast.
class CreatorPortalScreen extends ConsumerStatefulWidget {
  final void Function(IndieTrack track)? onTrackPublished;
  final void Function(String trackId, String targetZip, DateTime boostedUntil)?
      onTrackBoosted;

  const CreatorPortalScreen({
    super.key,
    this.onTrackPublished,
    this.onTrackBoosted,
  });

  @override
  ConsumerState<CreatorPortalScreen> createState() =>
      _CreatorPortalScreenState();
}

class _CreatorPortalScreenState extends ConsumerState<CreatorPortalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _cityController =
      TextEditingController(text: 'Atlanta');
  final TextEditingController _stateController =
      TextEditingController(text: 'GA');
  final TextEditingController _zipController =
      TextEditingController(text: '30308');
  final TextEditingController _signatureController = TextEditingController();

  String _selectedGenre = 'Southern Hip-Hop';
  final List<String> _genres = const <String>[
    'Southern Hip-Hop',
    'Alt R&B',
    'Trap Soul',
    'Indie Rock',
    'Electronic',
    'Afrobeats',
    'Jazz / Instrumental',
    'Boom Bap',
    'Pop',
  ];

  String? _selectedAudioFileName;
  String? _selectedAudioMimeType;
  int _selectedAudioSizeBytes = 0;
  String? _localAudioPath;
  String? _selectedCoverPath;

  bool _owns100Percent = false;
  bool _isPickingFile = false;

  @override
  void initState() {
    super.initState();
    _signatureController.addListener(() {
      setState(() {});
    });
    _titleController.addListener(() {
      setState(() {});
    });
    _artistController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  bool get _isWarrantyValid =>
      _owns100Percent && _signatureController.text.trim().length >= 2;

  bool get _canUpload =>
      _isWarrantyValid &&
      _selectedAudioFileName != null &&
      _titleController.text.trim().isNotEmpty &&
      _artistController.text.trim().isNotEmpty;

  Future<void> _pickAudioFile() async {
    setState(() => _isPickingFile = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['mp3', 'wav'],
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;
        final String name = file.name;
        final String ext = name.split('.').last.toLowerCase();
        final String mime = ext == 'wav' ? 'audio/wav' : 'audio/mpeg';

        setState(() {
          _selectedAudioFileName = name;
          _selectedAudioMimeType = mime;
          _selectedAudioSizeBytes = file.size;
          _localAudioPath = file.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File pick error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingFile = false);
      }
    }
  }

  void _selectDemoAudio() {
    setState(() {
      _selectedAudioFileName = 'atl_midnight_session.mp3';
      _selectedAudioMimeType = 'audio/mpeg';
      _selectedAudioSizeBytes = 3840000;
      _localAudioPath = 'mock://audio/atl_midnight_session.mp3';
      if (_titleController.text.isEmpty) {
        _titleController.text = 'Midnight on Peachtree';
      }
      if (_artistController.text.isEmpty) {
        _artistController.text = 'Peachtree Noir';
      }
    });
  }

  Future<void> _submitUpload() async {
    if (!_canUpload) return;

    final String city = _cityController.text.trim();
    final String citySlug = city.toLowerCase().replaceAll(' ', '_');

    final TrackUploadRequest request = TrackUploadRequest(
      artistId: 'artist-${_artistController.text.trim().toLowerCase().replaceAll(' ', '-')}',
      artistName: _artistController.text.trim(),
      title: _titleController.text.trim(),
      genre: _selectedGenre,
      citySlug: citySlug,
      cityName: city,
      stateCode: _stateController.text.trim().toUpperCase(),
      zipCode: _zipController.text.trim(),
      audioFileName: _selectedAudioFileName ?? 'audio.mp3',
      audioMimeType: _selectedAudioMimeType ?? 'audio/mpeg',
      audioSizeBytes: _selectedAudioSizeBytes,
      localAudioPath: _localAudioPath,
      localCoverPath: _selectedCoverPath,
      owns100Percent: _owns100Percent,
      signedName: _signatureController.text.trim(),
      signedAt: DateTime.now().toUtc(),
      attestationVersion: ComplianceConstants.rightsAttestationVersion,
    );

    try {
      final IndieTrack? track = await ref
          .read(creatorPortalControllerProvider.notifier)
          .uploadTrack(request);

      if (mounted && track != null) {
        widget.onTrackPublished?.call(track);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentEmerald,
            content: Text(
              'Track "${track.title}" published to Geo-Radio for ${track.cityName} (${track.zipCode})!',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );

        // Reset upload form
        _titleController.clear();
        setState(() {
          _selectedAudioFileName = null;
          _selectedAudioMimeType = null;
          _selectedAudioSizeBytes = 0;
          _localAudioPath = null;
          _owns100Percent = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentCrimson,
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void _openBoostSheet(IndieTrack track) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ArtistBoostSheet(
          track: track,
          onBoostPurchased: (String trackId, String targetZip, DateTime boostedUntil) {
            ref.read(creatorPortalControllerProvider.notifier).updateTrackBoost(
                  trackId: trackId,
                  targetZip: targetZip,
                  boostedUntil: boostedUntil,
                );
            widget.onTrackBoosted?.call(trackId, targetZip, boostedUntil);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<CreatorPortalState> portalAsync =
        ref.watch(creatorPortalControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Creator Portal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Hyper-Local Indie Radio Distribution',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.5)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.verified, size: 14, color: AppTheme.accentPurple),
                SizedBox(width: 4),
                Text(
                  '100% Indie',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: portalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object err, StackTrace st) => Center(
          child: Text('Error loading portal: $err',
              style: const TextStyle(color: AppTheme.accentCrimson)),
        ),
        data: (CreatorPortalState state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildUploadCard(state),
                  const SizedBox(height: 24),
                  _buildPublishedTracksHeader(state.publishedTracks.length),
                  const SizedBox(height: 12),
                  _buildPublishedTracksList(state.publishedTracks),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadCard(CreatorPortalState state) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final String formattedDate = formatter.format(DateTime.now());

    return Card(
      color: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.cloud_upload_outlined, color: AppTheme.accentCyan),
                SizedBox(width: 8),
                Text(
                  'Publish New Track',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Distribute your original music directly to drivers listening in your neighborhood.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const Divider(height: 24, color: AppTheme.borderSubtle),

            // Audio Picker Section
            const Text(
              '1. Master Audio File (MP3 or WAV)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentCyan,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_selectedAudioFileName != null)
                    Row(
                      children: <Widget>[
                        const Icon(Icons.audio_file, color: AppTheme.accentEmerald),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _selectedAudioFileName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${(_selectedAudioSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB • ${_selectedAudioMimeType ?? 'audio/mpeg'}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedAudioFileName = null;
                              _selectedAudioMimeType = null;
                              _selectedAudioSizeBytes = 0;
                              _localAudioPath = null;
                            });
                          },
                        ),
                      ],
                    )
                  else
                    const Text(
                      'No audio file selected yet. Max 25 MB.',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      OutlinedButton.icon(
                        key: const Key('creator_pick_file_button'),
                        icon: _isPickingFile
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.folder_open, size: 16),
                        label: const Text('Pick MP3 / WAV'),
                        onPressed: _isPickingFile ? null : _pickAudioFile,
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        key: const Key('creator_demo_audio_button'),
                        icon: const Icon(Icons.flash_on, size: 16, color: AppTheme.accentAmber),
                        label: const Text(
                          'Select Demo Indie Audio',
                          style: TextStyle(color: AppTheme.accentAmber, fontSize: 12),
                        ),
                        onPressed: _selectDemoAudio,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metadata Fields
            const Text(
              '2. Track & Broadcast Details',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentCyan,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('creator_track_title_field'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Track Title',
                hintText: 'e.g., Midnight Run',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const Key('creator_artist_name_field'),
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'Artist / Band Name',
                hintText: 'e.g., Zone 6 Collective',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: const Key('creator_genre_dropdown'),
              initialValue: _selectedGenre,
              decoration: const InputDecoration(labelText: 'Musical Genre'),
              dropdownColor: AppTheme.surfaceElevated,
              items: _genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedGenre = value);
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: const Key('creator_city_field'),
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    key: const Key('creator_state_field'),
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    key: const Key('creator_zip_field'),
                    controller: _zipController,
                    decoration: const InputDecoration(labelText: 'ZIP Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mandatory Rights Warranty Card
            Container(
              key: const Key('creator_rights_warranty_card'),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentAmber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _owns100Percent
                      ? AppTheme.accentEmerald
                      : AppTheme.accentAmber.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      Icon(Icons.gavel, color: AppTheme.accentAmber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Mandatory Rights Warranty & DMCA Safe Harbor',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    key: const Key('creator_warranty_checkbox'),
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.accentEmerald,
                    title: const Text(
                      'I warrant and attest that I own 100% of the master recording and '
                      'publishing rights to this audio and have not assigned exclusive '
                      'distribution rights to any third-party label or publisher.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    value: _owns100Percent,
                    onChanged: (bool? val) {
                      setState(() => _owns100Percent = val ?? false);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('creator_signature_field'),
                    controller: _signatureController,
                    decoration: const InputDecoration(
                      labelText: 'Typed Legal Electronic Signature',
                      hintText: 'Type your full legal name (e.g., Marcus Vance)',
                      helperText: 'Required for DMCA Safe Harbor attestation',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Attestation: ${ComplianceConstants.rightsAttestationVersion}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        'Date: $formattedDate UTC',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Error Message Display
            if (state.uploadError != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentCrimson.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentCrimson),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.error_outline,
                        color: AppTheme.accentCrimson, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.uploadError!,
                        style: const TextStyle(
                          color: AppTheme.accentCrimson,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                key: const Key('creator_upload_submit_button'),
                icon: state.isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF06131F),
                        ),
                      )
                    : const Icon(Icons.publish),
                label: Text(
                  state.isUploading
                      ? 'Validating & Uploading...'
                      : 'Certify Rights & Publish to Geo-Radio',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: (_canUpload && !state.isUploading)
                    ? _submitUpload
                    : null,
              ),
            ),
            if (!_canUpload)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    !_owns100Percent
                        ? 'Check 100% rights warranty box to enable upload'
                        : _signatureController.text.trim().length < 2
                            ? 'Type legal electronic signature to enable upload'
                            : _selectedAudioFileName == null
                                ? 'Select MP3/WAV audio file to enable upload'
                                : 'Enter track title and artist name to enable upload',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishedTracksHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.queue_music, color: AppTheme.accentAmber, size: 20),
            const SizedBox(width: 8),
            Text(
              'Your Published Tracks ($count)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const Text(
          'Geo-Radio Active',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.accentEmerald,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPublishedTracksList(List<IndieTrack> tracks) {
    if (tracks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderSubtle),
        ),
        child: const Center(
          child: Text(
            'No published tracks yet. Upload your first indie track above.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final IndieTrack track = tracks[index];
        final bool isBoosted = track.boostedUntil != null &&
            track.boostedUntil!.isAfter(DateTime.now());

        return Card(
          color: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isBoosted ? AppTheme.accentAmber : AppTheme.borderSubtle,
              width: isBoosted ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.music_note,
                          color: AppTheme.accentCyan),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            track.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${track.artistName} • ${track.genre}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isBoosted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.accentAmber),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.bolt,
                                color: AppTheme.accentAmber, size: 14),
                            SizedBox(width: 2),
                            Text(
                              'BOOSTED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentAmber,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    const Icon(Icons.location_on,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${track.cityName}, ${track.stateCode} (${track.zipCode})',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const Spacer(),
                    const Icon(Icons.play_arrow,
                        size: 14, color: AppTheme.textSecondary),
                    Text(
                      ' ${track.playCount} plays',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const Divider(height: 16, color: AppTheme.borderSubtle),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Warranty: ${track.rightsWarranty.signedName}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    ElevatedButton.icon(
                      key: Key('boost_button_${track.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentAmber,
                        foregroundColor: const Color(0xFF1A1100),
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      icon: const Icon(Icons.rocket_launch, size: 14),
                      label: Text(
                        isBoosted ? 'Boost Active' : 'Boost to City / ZIP',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () => _openBoostSheet(track),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
