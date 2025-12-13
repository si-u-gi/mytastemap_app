import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/store_api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final params = const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (message) {
          debugPrint("JS → Flutter: ${message.message}");
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            await _loadMarkers();
          },
        ),
      )
      ..loadFlutterAsset('assets/map.html');
  }

  Future<void> _loadMarkers() async {
    try {
      final stores = await fetchStores(37.4979, 127.0276);
      final jsonData = jsonEncode(stores);

      await _controller.runJavaScript("""
        if (typeof drawMarkers === 'function') {
          drawMarkers($jsonData);
        } else {
          console.error('drawMarkers is not defined');
        }
      """);
    } catch (e) {
      debugPrint("❌ 지도 데이터 로드 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내 주변 맛집")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
