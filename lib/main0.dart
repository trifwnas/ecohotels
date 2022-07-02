import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const EcoHotelsApp());
}

class EcoHotelsApp extends StatefulWidget {
  const EcoHotelsApp({Key? key}) : super(key: key);

  @override
  EcoHotelsAppState createState() => EcoHotelsAppState();
}

class EcoHotelsAppState extends State<EcoHotelsApp> {
  bool isLoading = true;

  late WebViewController webView;

  Future<bool> _onBack() async {
    var value = await webView.canGoBack();

    if (value) {
      await webView.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBack(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: 'https://ecohotels.com/',
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://ecohotels.com/')) {
                    return NavigationDecision.navigate;
                  } else {
                    launchUrl(request.url as Uri);
                    return NavigationDecision.prevent;
                  }
                },
                onPageStarted: (url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onPageFinished: (status) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onWebViewCreated: (WebViewController controller) {
                  webView = controller;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
