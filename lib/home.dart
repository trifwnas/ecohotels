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
        backgroundColor: const Color(0xff27a495),
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                zoomEnabled: false,
                initialUrl:
                    'https://ecohotels.com/?mobile_webview_app=50e8909b-d860-47c6-a46a-e27a8af112d0',
                onWebViewCreated: (WebViewController controller) {
                  webView = controller;
                },
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                backgroundColor: const Color(0xff27a495),
                navigationDelegate: (navigation) {
                  final host = Uri.parse(navigation.url).host;
                  if (host.contains('ecohotels.com')) {
                    return NavigationDecision.navigate;
                  }
                  final Uri url = Uri.parse(navigation.url);
                  _launchInBrowser(url);
                  return NavigationDecision.prevent;
                },
                //onWebResourceError:
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*
    Future<void> _noInternetLoadAsset(
        WebViewController controller, BuildContext context) async {
      await controller.loadFlutterAsset('assets/www/nointernet.html');
    }*/
}
