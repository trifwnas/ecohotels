import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  BlogState createState() => BlogState();
}

class BlogState extends State<Blog> {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBack(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: 'https://blog.ecohotels.com/',
                onWebViewCreated: (WebViewController controller) {
                  webView = controller;
                },
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                navigationDelegate: (navigation) {
                  final host = Uri.parse(navigation.url).host;
                  if (host.contains('ecohotels.com')) {
                    return NavigationDecision.navigate;
                  }
                  launchUrl(host.toString() as Uri);
                  return NavigationDecision.prevent;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
