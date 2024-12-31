import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:ofiouchos/game_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                    onPressed: () async {
                      FirebaseAnalytics.instance.logEvent(name: "play_keio");
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('塾生・塾員モード', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.black,
                          content: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/keyboard_keio.png'),
                                const Text('塾生・塾員モードは、全社会の先導者たらんことを欲す、誇り高き塾関係者のためのモードです。某大学を想起するWASDキーの代わりに、慶應義塾のKEIOキーを用いて操作ができるようになります。安心ですね\nスマホ版の場合はなんら変わりません', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('無理', style: TextStyle(fontSize: 24, color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage(isKeioMode: true,)));
                              },
                              child: const Text('プレイ', style: TextStyle(fontSize: 24, color: Colors.white)),
                            ),
                          ],
                        );
                      });
                    },
                    child: const Text('塾生・塾員モード', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "how_to_play");
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('Οφιούχοςの遊び方', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.blueGrey.shade900,
                          content: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 600),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 4),
                                    ),
                                    child: Image.asset('assets/snake.png'),
                                  ),
                                  const Text('あけましておめでとうございます。\n'
                            'Οφιούχος(オフューホス)は、2匹のヘビを操り、スコアを集める年賀状ゲームです。\n'
                            '壁や他のヘビ、自身の身体にぶつからないように、白い玉を集めましょう。', style: TextStyle(color: Colors.white, fontSize: 20)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: const Text('操作方法', style: TextStyle(color: Colors.white, fontSize: 48)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text('スマホ版', style: TextStyle(color: Colors.white, fontSize: 36)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 4),
                                    ),
                                    child: Image.asset('assets/control_phone.png'),
                                  ),
                                  const Text('画面下部にジョイスティックが2つあるので、それぞれのヘビを進ませたい方向に弾いてください。指を離したときに入力されます。', style: TextStyle(color: Colors.white, fontSize: 20)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: const Text('PC版', style: TextStyle(color: Colors.white, fontSize: 36)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 4),
                                    ),
                                    child: Image.asset('assets/control_pc.png')
                                  ),
                                  const Text('ジョイスティックの下部にあるキーを使って操作します。ヘビの動かしたい方向のキーを押下してください。', style: TextStyle(color: Colors.white, fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('わかった', style: TextStyle(fontSize: 24, color: Colors.white)),
                            ),
                          ],
                        );
                      });
                    },
                    child: const Text('遊び方', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      showPrevGames(context, "過去のゲームたち");
                    },
                    child: const Text('過去のゲームたち', style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: "license");
                      showLicensePage(context: context);
                    },
                    child: const Text('ライセンス', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("© 2025 fastriver_org", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      )
    );
  }
}

Future<void> showPrevGames(BuildContext context, String content) async {
  FirebaseAnalytics.instance.logEvent(name: "game_dialog");
  await showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      title: const Text('歴代年賀状たち', style: TextStyle(color: Colors.white)),
      content: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              await launchUrlString("https://year-greeting-condition2020.fastriver.dev/");
            }, 
            icon: Image.asset("assets/2020.png", width: 48, height: 48),
            tooltip: "年賀状2020",
          ),
          IconButton(
            onPressed: () async {
              await launchUrlString("https://p987.fastriver.dev/");
            }, 
            icon: Image.asset("assets/2021.png", width: 48, height: 48),
            tooltip: "p987",
          ),
          IconButton(
            onPressed: () async {
              await launchUrlString("https://tora.fastriver.dev/#/");
            }, 
            icon: Image.asset("assets/2022.png", width: 48, height: 48),
            tooltip: "アウ[トラ]イツ",
          ),
          IconButton(
            onPressed: () async {
              await launchUrlString("https://usapyon.fastriver.dev/");
            }, 
            icon: Image.asset("assets/2023.png", width: 48, height: 48),
            tooltip: "帰ってきた！うさぴょん",
          ),
          IconButton(
            onPressed: () async {
              await launchUrlString("https://toryumon.fastriver.dev/");
            }, 
            icon: Image.asset("assets/2024.png", width: 48, height: 48),
            tooltip: "登竜門",
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
            }, 
            icon: Image.asset("assets/2025.png", width: 48, height: 48),
            tooltip: "Οφιούχος",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('戻る', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  });
}