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
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent) // ✅ 추가
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) => loadMarkers(),
      ),
    )
    ..loadRequest(Uri.parse("https://map.siugi.dev/map.html"));
  }

  Future<void> loadMarkers({
    double minRating = 0,
    int minReview = 0,
  }) async {
    final stores = await fetchStores(
      minRating: minRating,
      minReview: minReview,
    );

    controller.runJavaScript(
      "drawMarkers(${jsonEncode(stores)});",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내 주변 맛집")),
      body: WebViewWidget(controller: controller),
    );
  }
}
