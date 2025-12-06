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
      ..loadFlutterAsset("assets/map.html");

    loadMarkers();
  }

  Future<void> loadMarkers() async {
    final stores = await fetchStores(37.4979, 127.0276);

    final js = "drawMarkers(${jsonEncode(stores)});";
    await controller.runJavaScript(js);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내 주변 맛집")),
      body: WebViewWidget(controller: controller),
    );
  }
}