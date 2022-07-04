import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
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
                initialUrl: 'https://ecohotels.com/',
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
                  final Uri url = Uri.parse(navigation.url);
                  _launchInBrowser(url);
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
