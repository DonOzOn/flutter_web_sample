import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miniapp_web/gamer/gamer.dart';
import 'package:miniapp_web/gamer/keyboard.dart';
import 'package:miniapp_web/simple_l10n.dart';
import 'package:miniapp_web/panel/page_portrait.dart';
import 'package:web/web.dart' as web;

class TetrisGameView extends StatefulWidget {
  const TetrisGameView({super.key});

  @override
  State<TetrisGameView> createState() => _TetrisGameViewState();
}

const screenBorderWidth = 3.0;

const backgroundColor = Color(0xffefcc19);

class _TetrisGameViewState extends State<TetrisGameView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tetris',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: const Game(child: KeyboardController(child: PagePortrait())),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
