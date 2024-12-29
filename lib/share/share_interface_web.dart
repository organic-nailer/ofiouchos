// share_interface_web.dart
// Web用のファイル

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import './share_interface.dart';

class ShareInterfaceWeb implements ShareInterface {
  @override
  share({required String content}) async {
    final html.Navigator navigator = html.window.navigator;
    await navigator.share({'text': content});
  }
}

ShareInterface getShareInstance() => ShareInterfaceWeb();