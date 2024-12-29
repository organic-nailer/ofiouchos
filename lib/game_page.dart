import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ofiouchos/game/snake_game.dart';
import 'package:ofiouchos/share/share.dart';
import 'package:ofiouchos/util/direction.dart';
import 'package:ofiouchos/util/faces.dart';
import 'package:ofiouchos/view/joystick.dart';

class GamePage extends StatefulWidget {
  final bool isKeioMode;
  const GamePage({super.key, this.isKeioMode = false});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late SnakeGameInterface game;
  bool isGameOver = false;
  bool showNovel = false;
  late final FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.requestFocus();
    game = SnakeGame(isKeioMode: widget.isKeioMode);
    game.setOnGameOverCallback(() {
      setState(() {
        FirebaseAnalytics.instance.logPostScore(
          score: game.score,
          level: game.score,
          character: 'snake',
        );
        isGameOver = true;
      });
    });
    game.setOnUpgradeCallback(() => setState(() {}));
  }

  void resetGame() {
    FirebaseAnalytics.instance.logEvent(
      name: "reset_game",
    );
    setState(() {
      isGameOver = false;
      game = SnakeGame(isKeioMode: widget.isKeioMode);
      game.setOnGameOverCallback(() {
        setState(() {
        FirebaseAnalytics.instance.logPostScore(
          score: game.score,
          level: game.score,
          character: 'snake',
        );
          isGameOver = true;
        });
      });
      game.setOnUpgradeCallback(() => setState(() {}));
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (widget.isKeioMode) {
        switch(event.logicalKey.keyLabel) {
        case 'K':
          game.requestControl(0, Direction.down);
          break;
        case 'E':
          game.requestControl(0, Direction.left);
          break;
        case 'I':
          game.requestControl(0, Direction.up);
          break;
        case 'O':
          game.requestControl(0, Direction.right);
          break;
        }
      }
      else {
        switch(event.logicalKey.keyLabel) {
        case 'W':
          game.requestControl(0, Direction.up);
          break;
        case 'A':
          game.requestControl(0, Direction.left);
          break;
        case 'S':
          game.requestControl(0, Direction.down);
          break;
        case 'D':
          game.requestControl(0, Direction.right);
          break;
        }
      }
      switch (event.logicalKey.keyLabel) {
        case 'Arrow Up':
          game.requestControl(1, Direction.up);
          break;
        case 'Arrow Left':
          game.requestControl(1, Direction.left);
          break;
        case 'Arrow Down':
          game.requestControl(1, Direction.down);
          break;
        case 'Arrow Right':
          game.requestControl(1, Direction.right);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: onKeyEvent,
        child: Center(
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return Column(
                        children: [
                          SizedBox(
                            height: width * 0.1,
                            child: Row(
                              children: [
                                Text(
                                  'Score: ${game.score}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.08,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GameWidget(game: game, autofocus: false,)
                            ),
                          ),
                          SizedBox(
                            height: width * 0.4,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: Joystick(
                                        onControl: (d) {
                                          if (d == Direction.none) return;
                                          game.requestControl(0, d);
                                        },
                                        size: width * 0.26,
                                        knobSize: width * 0.12,
                                        background: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius: BorderRadius.circular(width * 0.04),
                                          ),
                                        ),
                                        knob: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(width * 0.02),
                                          ),
                                          child: CustomPaint(
                                            painter: widget.isKeioMode 
                                              ? KeioFacePainter()
                                              : WasedaFacePainter(),
                                            child: SizedBox(
                                              width: 96,
                                              height: 96,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      spacing: width * 0.01,
                                      children: [
                                        buildKeyCap(
                                          widget.isKeioMode ? 'K' : 'W',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          widget.isKeioMode ? 'E' : 'A',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          widget.isKeioMode ? 'I' : 'S',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          widget.isKeioMode ? 'O' : 'D',
                                          width * 0.06,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: Joystick(
                                        onControl: (d) {
                                          if (d == Direction.none) return;
                                          game.requestControl(1, d);
                                        },
                                        size: width * 0.26,
                                        knobSize: width * 0.12,
                                        background: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius: BorderRadius.circular(width * 0.04),
                                          ),
                                        ),
                                        knob: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(width * 0.02),
                                          ),
                                          child: CustomPaint(
                                            painter: RectFacePainter(),
                                            child: SizedBox(
                                              width: 96,
                                              height: 96,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      spacing: width * 0.01,
                                      children: [
                                        buildKeyCap(
                                          '↑',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          '←',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          '↓',
                                          width * 0.06,
                                        ),
                                        buildKeyCap(
                                          '→',
                                          width * 0.06,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  ),
                ),
                IgnorePointer(
                  ignoring: !isGameOver,
                  child: AnimatedOpacity(
                    opacity: isGameOver ? 1 : 0, 
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                      color: Colors.black.withAlpha(200),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Game Over',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 96,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapUp: (d) {
                                setState(() {
                                  FirebaseAnalytics.instance.logEvent(
                                    name: "show_novel",
                                  );
                                  showNovel = !showNovel;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  scoreToGreeting(game.score).$1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedSize(
                              duration: Duration(milliseconds: 500),
                              alignment: Alignment.topCenter,
                              curve: Curves.easeInOut,
                              child: showNovel ? Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  scoreToGreeting(game.score).$2,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ) : Container(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Score: ${game.score} pt",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                FirebaseAnalytics.instance.logEvent(
                                  name: "share",
                                );
                                showShareDialog(context, "Οφιούχος - SCORE: ${game.score}");
                              },
                              child: Text(
                                '共有',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: resetGame,
                              child: Text(
                                '再挑戦',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseAnalytics.instance.logEvent(
                                  name: "back_to_title",
                                );
                                Navigator.pop(context);
                              },
                              child: Text(
                                '終了',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildKeyCap(String label, double width) {
  return SizedBox(
    width: width,
    height: width,
    child: FittedBox(
      fit: BoxFit.contain,
      child: CustomPaint(
        painter: KeyCapPainter(
          label: label,
        ),
        child: SizedBox(
          width: 96,
          height: 96,
        ),
      ),
    ),
  );
}

class KeyCapPainter extends CustomPainter {
  final String label;
  KeyCapPainter({required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height), 
        Radius.circular(16),
      ),
      Paint()..color = Colors.white,
    );

    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 75,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas, 
      Offset(
        (size.width - textPainter.width) / 2, 
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

(String, String) scoreToGreeting(int score) {
  if (score < 5) {
    return (
      "あけおめ！良い年にしよう！…すべては計画通りに。",
      "信は、年末に彩からプレゼントされたVRゲーム「Serpent's Eve」を起動する。ヘッドセットを装着すると、目の前には見慣れた街並みが広がっていた。「うわっ、すげーリアル！」思わず声が出る。彩のアバターが隣に現れ、「あけおめ、信！今年もよろしくね！」と手を振る。二人は、ゲームの世界で新年を迎えた。"
    );
  } else if (score < 10) {
    return (
      "おめでとう！…次はもっと深く潜れるはず！",
      "信と彩は、協力してゲームを進めていく。最初のステージは、街の中を探索し、隠されたアイテムを見つけるというものだった。信は、ビルの屋上、地下道、公園など、あらゆる場所をくまなく探す。彩は、「信、そっちじゃないよ！もっと奥！」と指示を出す。二人は、まるで宝探しをしているかのように、ゲームの世界に夢中になっていく。"
    );
  } else if (score < 15) {
    return (
      "あけおめ…寒気がする…まるで爬虫類になったみたい…？",
      "ゲームを進めるにつれて、信は奇妙な感覚に襲われる。「あれ？なんか寒気がする…」彩も、「私も…体が冷える感じ…」と答える。二人は、ゲームの影響で体温が下がっていることに気づく。その時、信の視界に、一瞬だけヘビの目が映る。彼は、その不気味な視線に背筋が凍る思いをする。"
    );
  } else if (score < 20) {
    return (
      "謹賀新年。「汝自身を知れ」。君は人間か？…それとも、蛇か？",
      "ゲームの主人公は、蛇の能力を手に入れ、徐々に蛇へと変貌していく。信は、ゲームの主人公に感情移入するあまり、自分自身も蛇になりつつあるような錯覚に陥る。「あれ…？俺、人間だよな…？」彩も、信の様子を見て不安を募らせる。「信…？大丈夫…？ちょっと変だよ…」"
    );
  } else if (score < 25) {
    return (
      "謹賀新年。抵抗は無意味。…我々の世界へようこそ。",
      "信と彩は、ゲームの世界で巨大な地下空間にたどり着く。そこには、無数の蛇が蠢き、人間を捕食している光景が広がっていた。「うわあああ！」彩は悲鳴を上げる。信も、その光景に言葉を失う。ゲームのNPCが、冷酷な声で告げる。「ここは、我々の世界だ。お前たち人間は、我々の支配下にある。」"
    );
  } else if (score < 30) {
    return (
      "謹賀新年…静かに。我々は見ている。…すべてを知っている。",
      "信と彩は、ゲームの世界からログアウトしようとするが、できない。「あれ？ログアウトできない…？」彩が焦る。信は、画面に表示されたメッセージに気づく。「我々は、お前たちの行動をすべて監視している。抵抗は無意味だ。」二人は、蛇に監視されていることに恐怖を感じる。"
    );
  } else if (score < 35) {
    return (
      "輝け…我々の世界で。…我々のために。",
      "蛇の支配する世界で、信と彩は奴隷として働かされることになる。重労働を強いられ、自由を奪われる。彩は、「こんなの…ひどい…」と涙を流す。信は、彩を守りたい一心で、必死に生き延びようとする。"
    );
  } else if (score < 40) {
    return (
      "おめでとう！従うなら安泰。…抵抗するなら…？",
      "信と彩は、蛇の兵士に捕らえられる。兵士は、二人に選択肢を与える。「我々に従うか、それとも死ぬか。」彩は怯えるが、信は決意を固める。「俺は…抵抗する！」"
    );
  } else if (score < 45) {
    return (
      "明けましておめでとう。…人類の最後の年になるかも。…あるいは…？",
      "蛇の支配は、現実世界にも広がりつつある。街中には蛇のシンボルが掲げられ、人々は蛇を崇拝するようになる。信と彩は、ゲームの世界だけでなく、現実世界でも蛇の脅威に立ち向かわなければならない。"
    );
  } else if (score < 50) {
    return (
      "謹んで…我々を愛せよ。…そうすれば、生き延びられる。",
      "蛇の宗教が世界を席巻する。信の両親も、蛇の信者となり、信に蛇への服従を強要する。「信…お願いだから…蛇様を信じなさい…」信は、大切な人を失う悲しみに暮れる。"
    );
  } else if (score < 55) {
    return (
      "明けましておめでとう。…君も…もう…我々の一員。",
      "信の体にも、異変が現れ始める。皮膚が鱗で覆われ、目が爬虫類のように変化していく。彩は、信の姿を見て絶望する。「信…どうなっちゃうの…？ 」"
    );
  } else if (score < 60) {
    return (
      "新年おめでとう！…共に踊りましょう。…我々の勝利のダンスを。",
      "蛇の支配が完成した世界。人間は蛇の奴隷となり、彼らのために踊る。信も、彩も、自我を失い、蛇の音楽に合わせて踊り続ける。彼らの心には、もはや希望の光はない。"
    );
  } else if (score < 65) {
    return (
      "あけおめ！…我々の支配を受け入れよ。…それが、人類の未来。",
      "蛇の支配下で、人間は家畜のように扱われる。信と彩は、狭い檻の中で暮らす。彼らの目は虚ろで、生きる希望を失っている。"
    );
  } else if (score < 70) {
    return (
      "謹賀新年…進化の時。…人類は、新たな段階へ。",
      "蛇の科学者たちは、人間の遺伝子を操作し、蛇の能力を持つ新人類を創造する。信と彩も、実験の対象となり、彼らの体は改造される。"
    );
  } else if (score < 75) {
    return (
      "おめでとう。…君は、もう我々の一員。…歓迎する。",
      "信は、蛇の能力を手に入れ、蛇の社会に受け入れられる。彩は、信が人間ではなくなったことに悲しみ、絶望する。"
    );
  } else if (score < 80) {
    return (
      "新年明けましておめでとう。…我々の世界へ。…永遠に。",
      "ゲームの世界と現実世界は完全に融合し、区別がつかなくなる。プレイヤーは、自分が蛇の支配する世界で生きていることを受け入れる。そこでは、人間はもはや存在しない。"
    );
  } else if (score < 85) {
    return (
      "謹んで…「我々の計画通り」。…すべては、この日のために。",
      "蛇の指導者は、高らかに宣言する。「我々の計画は成功した。人類は滅亡し、蛇の時代が到来した！」"
    );
  } else if (score < 90) {
    return (
      "おめでとう…？…人類の夢は…終わった…？…我々の夢が始まる。",
      "蛇の文明が栄える一方で、人間の文明は滅びる。かつて緑豊かだった地球は、蛇の毒によって汚染され、荒れ果てていく。"
    );
  } else if (score < 95) {
    return (
      "新年おめでとう！…我々は、常に君を見ている。…君の中に。",
      "彩は、蛇の支配から逃れようと、抵抗を続ける。しかし、彼女の心は、すでに蛇に蝕まれている。彼女は、自分が蛇の支配から逃れられないことを悟る。"
    );
  } else if (score < 100) {
    return (
      "謹賀新年…「人類は滅亡」。…我々の時代。…新たな秩序。",
      "蛇の支配する世界では、新たな秩序が築かれる。人間は、蛇の奴隷として、あるいは家畜として、生きる意味を見失っていく。"
    );
  } else {
    return (
      "おめでとう…「さようなら、人類」。…そして、…「ようこそ、新世界へ」。",
      "信は、蛇の将軍として、新世界の秩序を維持する役割を担う。彩は、信に捕らえられ、蛇の研究所に送られる。二人は、もはや会うことのない運命を辿る。"
    );
  }
}
