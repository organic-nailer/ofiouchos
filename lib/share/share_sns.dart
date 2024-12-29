import 'package:url_launcher/url_launcher_string.dart';

const shareUrl = "https://snake.fastriver.dev";

const _twitterShareLink = """https://twitter.com/intent/tweet?url=$shareUrl&text=""";

const _facebookShareLink = """http://www.facebook.com/share.php?u=$shareUrl""";

const _lineShareLink = """https://line.naver.jp/R/msg/text/?$shareUrl""";

void shareTwitter(String message) async {
  final encoded = Uri.encodeFull(message);
  await launchUrlString(_twitterShareLink + encoded);
}

void shareFacebook() async {
  await launchUrlString(_facebookShareLink);
}

void shareLine(String message) async {
  final encoded = Uri.encodeFull(message);
  await launchUrlString("$_lineShareLink $encoded");
}