import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofiouchos/game_page.dart';
import 'package:ofiouchos/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ofiouchos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white),
        useMaterial3: true,
        textTheme: GoogleFonts.dotGothic16TextTheme(),
      ),
      home: const StartPage(),
    );
  }
}
