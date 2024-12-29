// from: https://www.memory-lovers.blog/entry/2023/12/14/180209
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ofiouchos/share/share_sns.dart';
// dart:htmlがあるプラットフォームのときだけ、importを切り替える
import './share_interface.dart'
    if (dart.library.html) './share_interface_web.dart';
    
Future<void> doShare(BuildContext context, {required String content}) async {
  if (kIsWeb) {
    // webの場合は、とりあえず、Navigator.share()を試す
    try {
      final shareInstance = getShareInstance();
      await shareInstance.share(content: content);
    } on NoSuchMethodError catch (_) {
      if (!context.mounted) return;
    }
  } else {
    // web以外の場合は、share_plusを使う
    await Share.share(content);
  }
}

Future<void> showShareDialog(BuildContext context, String content) async {
  FirebaseAnalytics.instance.logEvent(name: "share_dialog");
  await showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      title: const Text('共有', style: TextStyle(color: Colors.white)),
      content: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: "share_copy");
              await Clipboard.setData(ClipboardData(text: "$content\n$shareUrl"));
            }, 
            icon: const Icon(Icons.copy, color: Colors.white70),
            tooltip: "Copy to clipboard",
          ),
          IconButton(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: "share_api");
              doShare(context, content: "$content\n$shareUrl");
            }, 
            icon: const Icon(Icons.share, color: Colors.white70),
            tooltip: "Share API",
          ),
          IconButton(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: "share_line");
              shareLine(content);
            }, 
            icon: Image.asset("assets/share/line.png", width: 32, height: 32),
            tooltip: "LINE",
          ),
          // IconButton(
          //   onPressed: () async {
          //     FirebaseAnalytics.instance.logEvent(name: "share_twitter");
          //     shareTwitter(content);
          //   }, 
          //   icon: Image.asset("assets/images/share/twitter.png", width: 32, height: 32),
          //   tooltip: "Twitter",
          // ),
          IconButton(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: "share_x");
              shareTwitter(content);
            }, 
            icon: Image.asset("assets/share/x.png", width: 32, height: 32),
            tooltip: "X",
          ),
          IconButton(
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: "share_facebook");
              shareFacebook();
            }, 
            icon: Image.asset("assets/share/facebook.png", width: 32, height: 32),
            tooltip: "Facebook",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  });
}
