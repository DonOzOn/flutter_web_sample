import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miniapp_web/gamer/block.dart';
// import 'package:miniapp_web/material/audios.dart';

///the height of game pad
const gamePadMatrixH = 20;

///the width of game pad
const gamePadMatrixW = 10;

///state of [GameControl]
enum GameStates {
  none,

  paused,

  running,

  reset,

  mixing,

  clear,

  drop,
}

class Game extends StatefulWidget {
  final Widget child;

  const Game({super.key, required this.child});

  @override
  State<StatefulWidget> createState() {
    return GameControl();
  }

  static GameControl of(BuildContext context) {
    final state = context.findAncestorStateOfType<GameControl>();
    if (state == null) {
      throw FlutterError(
          'Game.of(context) called with a context that does not contain a Game widget.');
    }
    return state;
  }
}

///duration for show a line when reset
const restLineDuration = Duration(milliseconds: 50);

const levelMax = 6;

const levelMin = 1;

const speed = [
  Duration(milliseconds: 800),
  Duration(milliseconds: 650),
  Duration(milliseconds: 500),
  Duration(milliseconds: 370),
  Duration(milliseconds: 250),
  Duration(milliseconds: 160),
];

class GameControl extends State<Game> with RouteAware {
  GameControl() {
    //inflate game pad data
    for (int i = 0; i < gamePadMatrixH; i++) {
      _data.add(List.filled(gamePadMatrixW, 0));
      _mask.add(List.filled(gamePadMatrixW, 0));
    }
    debugPrint("GameControl initialized with ${_data.length} rows and ${_data[0].length} columns");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _autoFall(false);
    super.dispose();
  }

  @override
  void didPushNext() {
    //pause when screen is at background
    pause();
  }

  ///the gamer data
  final List<List<int>> _data = [];

  final List<List<int>> _mask = [];

  ///from 1-6
  int _level = 1;

  int _points = 0;

  int _cleared = 0;

  Block? _current;

  Block _next = Block.getRandom();

  GameStates _states = GameStates.none;

  Block _getNext() {
    final next = _next;
    _next = Block.getRandom();
    return next;
  }

  // SoundState get _sound => Sound.of(context);

  void rotate() {
    if (_states == GameStates.running) {
      final next = _current?.rotate();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.rotate();
      }
    }
    setState(() {});
  }

  void right() {
    if (_states == GameStates.none && _level < levelMax) {
      _level++;
    } else if (_states == GameStates.running) {
      final next = _current?.right();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.move();
      }
    }
    setState(() {});
  }

  void left() {
    if (_states == GameStates.none && _level > levelMin) {
      _level--;
    } else if (_states == GameStates.running) {
      final next = _current?.left();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.move();
      }
    }
    setState(() {});
  }

  void drop() async {
    debugPrint("Drop called, current state: $_states");
    if (_states == GameStates.running) {
      for (int i = 0; i < gamePadMatrixH; i++) {
        final fall = _current?.fall(step: i + 1);
        if (fall != null && !fall.isValidInMatrix(_data)) {
          _current = _current?.fall(step: i);
          _states = GameStates.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          if (!mounted) return;
          _mixCurrentIntoData();
          break;
        }
      }
      setState(() {});
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      debugPrint("Starting game from drop");
      _startGame();
    }
  }

  void down({bool enableSounds = true}) {
    if (_states == GameStates.running) {
      final next = _current?.fall();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          // _sound.move();
        }
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  Timer? _autoFallTimer;

  ///mix current into [_data]
  Future<void> _mixCurrentIntoData() async {
    if (_current == null) {
      return;
    }
    //cancel the auto falling task
    _autoFall(false);

    _forTable((i, j) => _data[i][j] = _current?.get(j, i) ?? _data[i][j]);

    //消除行
    final clearLines = [];
    for (int i = 0; i < gamePadMatrixH; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      setState(() => _states = GameStates.clear);

      // _sound.clear();

      ///消除效果动画
      for (int count = 0; count < 5; count++) {
        for (var line in clearLines) {
          _mask[line].fillRange(0, gamePadMatrixW, count % 2 == 0 ? -1 : 1);
        }
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }
      for (var line in clearLines) {
        _mask[line].fillRange(0, gamePadMatrixW, 0);
      }

      //移除所有被消除的行
      for (var line in clearLines) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(gamePadMatrixW, 0);
      }
      debugPrint("clear lines : $clearLines");

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;

      //up level possible when cleared
      int level = (_cleared ~/ 50) + levelMin;
      _level = level <= levelMax && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      // mixSound?.call();
      _forTable((i, j) => _mask[i][j] = _current?.get(j, i) ?? _mask[i][j]);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _forTable((i, j) => _mask[i][j] = 0);
      setState(() {});
    }

    //_current已经融入_data了，所以不再需要
    _current = null;

    //检查游戏是否结束,即检查第一行是否有元素为1
    if (_data[0].contains(1)) {
      reset();
      return;
    } else {
      //游戏尚未结束，开启下一轮方块下落
      _startGame();
    }
  }

  ///遍历表格
  ///i 为 row
  ///j 为 column
  static void _forTable(dynamic Function(int row, int column) callback) {
    for (int i = 0; i < gamePadMatrixH; i++) {
      for (int j = 0; j < gamePadMatrixW; j++) {
        final b = callback(i, j);
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  void _autoFall(bool enable) {
    if (!enable) {
      _autoFallTimer?.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      debugPrint("Starting auto fall with current piece: ${_current?.type}");
      _autoFallTimer = Timer.periodic(speed[_level - 1], (t) {
        if (!mounted) return;
        down(enableSounds: false);
      });
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    setState(() {});
  }

  void pauseOrResume() {
    if (_states == GameStates.running) {
      pause();
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void reset() {
    debugPrint("Reset called");
    if (_states == GameStates.none) {
      _startGame();
      return;
    }
    if (_states == GameStates.reset) return;

    _states = GameStates.reset;

    () async {
      int line = gamePadMatrixH;

      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 1;
        }
        if (!mounted) return false;
        setState(() {});
        await Future.delayed(restLineDuration);
        return line != 0;
      });

      _current = null;
      _getNext();
      _points = 0;
      _cleared = 0;

      await Future.doWhile(() async {
        for (int i = 0; i < gamePadMatrixW; i++) {
          _data[line][i] = 0;
        }
        if (!mounted) return false;
        setState(() {});
        line++;
        await Future.delayed(restLineDuration);
        return line != gamePadMatrixH;
      });

      if (!mounted) return;
      setState(() {
        _states = GameStates.none;
      });
    }();
  }

  void _startGame() {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }
    debugPrint("Starting game, current state: $_states");
    _states = GameStates.running;
    _autoFall(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    for (var i = 0; i < gamePadMatrixH; i++) {
      mixed.add(List.filled(gamePadMatrixW, 0));
      for (var j = 0; j < gamePadMatrixW; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    debugPrint("Game build called - state: $_states, level: $_level, points: $_points");
    return GameState(mixed, _states, _level, _points, _cleared, _next,
        child: widget.child);
  }

  void soundSwitch() {
    // setState(() {
    //   _sound.mute = !_sound.mute;
    // });
  }
}

class GameState extends InheritedWidget {
  const GameState(
    this.data,
    this.states,
    this.level,
    // this.muted,
    this.points,
    this.cleared,
    this.next, {
    super.key,
    required super.child,
  });

  /// Brick data
  ///0: empty
  ///1: normal
  ///2: highlight
  final List<List<int>> data;

  final GameStates states;

  final int level;

  // final bool muted;

  final int points;

  final int cleared;

  final Block next;

  static GameState of(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<GameState>();
    if (state == null) {
      throw FlutterError(
          'GameState.of(context) called with a context that does not contain a GameState.\n'
          'Make sure your widget is wrapped in a Game widget above in the widget tree.');
    }
    return state;
  }

  @override
  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
