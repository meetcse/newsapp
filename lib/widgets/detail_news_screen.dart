import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNewsScreen extends StatefulWidget {
  final String postUrl;
  final String title;
  DetailNewsScreen({@required this.postUrl, @required this.title});

  @override
  _DetailNewsScreen createState() => _DetailNewsScreen();
}

class _DetailNewsScreen extends State<DetailNewsScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.myAppBar(context, title: widget.title),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.postUrl,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
