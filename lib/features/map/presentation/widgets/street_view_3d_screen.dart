import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/config/app_env.dart';
import '../../../../core/theme/app_theme.dart';

/// Full-screen 3D photorealistic inspection screen backed by CesiumJS inside
/// `assets/web/cesium_3d_viewer.html`.
///
/// Calls `initCrimeMaps3D(lat, lng, label, AppEnv.googleMapsApiKey)` once the
/// local HTML viewer finishes loading, and presents a clear fallback banner
/// when no Google Maps API key is configured or offline.
class StreetView3dScreen extends StatefulWidget {
  const StreetView3dScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  final double latitude;
  final double longitude;
  final String label;

  @override
  State<StreetView3dScreen> createState() => _StreetView3dScreenState();
}

class _StreetView3dScreenState extends State<StreetView3dScreen> {
  static const String _viewerAssetPath = 'assets/web/cesium_3d_viewer.html';

  WebViewController? _webController;
  bool _isLoading = true;
  String? _webError;

  @override
  void initState() {
    super.initState();
    unawaited(_initWebView());
  }

  Future<void> _initWebView() async {
    try {
      final controller = WebViewController();
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(AppTheme.bgDark);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            unawaited(_invokeCesiumInit());
          },
          onWebResourceError: (WebResourceError error) {
            if (!mounted) return;
            setState(() {
              _webError = error.description;
              _isLoading = false;
            });
          },
        ),
      );
      if (!mounted) return;
      setState(() {
        _webController = controller;
      });
      await controller.loadFlutterAsset(_viewerAssetPath);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _webError = 'Interactive 3D WebView is unavailable on this runtime.';
        _isLoading = false;
      });
    }
  }

  Future<void> _invokeCesiumInit() async {
    final controller = _webController;
    if (controller == null) return;

    final encodedLabel = jsonEncode(widget.label);
    final encodedApiKey = jsonEncode(AppEnv.googleMapsApiKey);
    final script =
        'if (window.initCrimeMaps3D) { '
        'window.initCrimeMaps3D(${widget.latitude}, ${widget.longitude}, $encodedLabel, $encodedApiKey); '
        '}';

    try {
      await controller.runJavaScript(script);
    } catch (_) {
      // Cesium viewer displays its own fallback HUD if JS execution fails.
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchExternalStreetView() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/@?api=1&map_action=pano'
      '&viewpoint=${widget.latitude},${widget.longitude}',
    );
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open external Google Street View.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showKeyBanner = !AppEnv.hasGoogleMapsKey;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('3D Location Inspection'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Open in Street View',
            icon: const Icon(Icons.streetview_rounded),
            onPressed: _launchExternalStreetView,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (showKeyBanner || _webError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.accentAmber.withValues(alpha: 0.14),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.accentAmber.withValues(alpha: 0.45),
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppTheme.accentAmber,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _webError != null
                          ? '3D Preview Fallback: $_webError'
                          : 'Standard 3D globe preview active. Supply GOOGLE_MAPS_API_KEY via --dart-define for Google Photorealistic 3D Tiles.',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _webController != null && _webError == null
                ? Stack(
                    children: <Widget>[
                      WebViewWidget(controller: _webController!),
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  )
                : _Offline3dFallbackView(
                    label: widget.label,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    onOpenStreetView: _launchExternalStreetView,
                  ),
          ),
        ],
      ),
    );
  }
}

class _Offline3dFallbackView extends StatelessWidget {
  const _Offline3dFallbackView({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.onOpenStreetView,
  });

  final String label;
  final double latitude;
  final double longitude;
  final VoidCallback onOpenStreetView;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.view_in_ar_rounded,
                size: 48,
                color: AppTheme.accentCyan,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Coordinates: ${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onOpenStreetView,
                  icon: const Icon(Icons.streetview_rounded),
                  label: const Text('Open Interactive Street View'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
