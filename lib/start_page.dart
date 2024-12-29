import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:ofiouchos/game_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Expanded(
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Image.asset('assets/logo.png'),
                )),
              ),
              Column(
                spacing: 24,
                children: [
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "play");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
                    },
                    child: const Text('プレイ', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "play_keio");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage(isKeioMode: true,)));
                    },
                    child: const Text('塾生・塾員モード', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "how_to_play");
                    },
                    child: const Text('遊び方', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "license");
                      showLicensePage(context: context);
                    },
                    child: const Text('ライセンス', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("©fastriver_org 2025", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      )
    );
  }
}
