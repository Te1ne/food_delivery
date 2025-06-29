import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ZaloPayWebView extends StatefulWidget {
  final String orderUrl;

  const ZaloPayWebView({super.key, required this.orderUrl});

  @override
  State<ZaloPayWebView> createState() => _ZaloPayWebViewState();
}

class _ZaloPayWebViewState extends State<ZaloPayWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final params = PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
            onNavigationRequest: (request) async {
              final url = request.url;

              if (url.startsWith('zalopay://')) {
                // Chặn trước, không để WebView load
                try {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Không thể mở URL: $e');
                }
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            }
        ),
      )
      ..loadRequest(Uri.parse(widget.orderUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán ZaloPay')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
