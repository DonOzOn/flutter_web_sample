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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final message = {'type': 'score-update', 'value': "onBack"};
              // ignore: invalid_runtime_check_with_js_interop_types
              web.window.parent?.postMessage(message as JSAny?, '*' as JSAny);
            },
          ),
          centerTitle: true,
          title: const Text(
            'Tetris Game11',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: const Game(child: KeyboardController(child: PagePortrait())),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
