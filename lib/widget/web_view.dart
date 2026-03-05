import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/app_constants.dart';

class WebView extends StatefulWidget {
  final String url;
  final void Function(int progress, String url)? onProgressChanged; // callback with progress & url
  final void Function(String url)? onPageLoaded; // callback when page fully loaded
  final void Function(String url)? successOrFail; // callback when page fully loaded

  const WebView({
    Key? key,
    required this.url,
    this.onProgressChanged,
    this.onPageLoaded,
    this.successOrFail,
  }) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;
  int _progress = 0;
  String _currentUrl = "";
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) async {
            if(progress == 100){
              loaded = true;
            }
            final url = await _controller.currentUrl() ?? widget.url;
            if (!mounted) return;  // ✅ Check if widget is still in the tree
            setState(() {
              _progress = progress;
              _currentUrl = url;
            });
            widget.onProgressChanged?.call(progress, url);
          },
          onPageFinished: (url) {
            widget.onPageLoaded?.call(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Trying to load: ${request.url}");

            // 🔹 Handle callback when URL changes
            // if (request.url.contains("success")) {
              debugPrint("Success or fail callback!");
              widget.successOrFail?.call(request.url);
            // }

            return NavigationDecision.navigate; // allow navigation
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !loaded ? Center(child: const CircularProgressIndicator()) :  WebViewWidget(controller: _controller);
  }
}
