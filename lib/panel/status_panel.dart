import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miniapp_web/gamer/block.dart';
import 'package:miniapp_web/gamer/gamer.dart';
import 'package:miniapp_web/simple_l10n.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("StatusPanel build started");

    try {
      final gameState = GameState.of(context);
      debugPrint(
        "StatusPanel - points: ${gameState.points}, level: ${gameState.level}",
      );

      return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.green.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).points,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            _NumberDisplay(number: gameState.points),
            const SizedBox(height: 10),
            Text(
              S.of(context).cleans,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            _NumberDisplay(number: gameState.cleared),
            const SizedBox(height: 10),
            Text(
              S.of(context).level,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            _NumberDisplay(number: gameState.level),
            const SizedBox(height: 10),
            Text(
              S.of(context).next,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            _NextBlock(),
            const Spacer(),
            _GameStatus(),
          ],
        ),
      );
    } catch (e) {
      debugPrint("Error in StatusPanel: $e");
      return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.green.withOpacity(0.1),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Points",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text("0", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "Level",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text("1", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "Next",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 4),
            Icon(Icons.crop_square, size: 40, color: Colors.black54),
          ],
        ),
      );
    }
  }
}

class _NumberDisplay extends StatelessWidget {
  final int number;

  const _NumberDisplay({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        number.toString().padLeft(5, ' '),
        style: const TextStyle(
          color: Colors.green,
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      final gameState = GameState.of(context);
      List<List<int>> data = [
        List.filled(4, 0),
        List.filled(4, 0),
        List.filled(4, 0),
        List.filled(4, 0),
      ];

      final next = blockShapes[gameState.next.type]!;
      for (int i = 0; i < next.length && i < 4; i++) {
        for (int j = 0; j < next[i].length && j < 4; j++) {
          data[i][j] = next[i][j];
        }
      }

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Column(
          children:
              data.map((list) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      list.map((b) {
                        return Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                            color: b == 1 ? Colors.black87 : Colors.transparent,
                            border: Border.all(
                              color: b == 1 ? Colors.black87 : Colors.black12,
                              width: 1,
                            ),
                          ),
                        );
                      }).toList(),
                );
              }).toList(),
        ),
      );
    } catch (e) {
      debugPrint("Error in _NextBlock: $e");
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          color: Colors.white.withOpacity(0.5),
        ),
        child: const Icon(Icons.crop_square, size: 40, color: Colors.black54),
      );
    }
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;
  bool _colonEnable = true;
  int _minute = 0;
  int _hour = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      final gameState = GameState.of(context);
      final isPaused = gameState.states == GameStates.paused;

      return Row(
        children: <Widget>[
          Icon(
            isPaused ? Icons.pause : Icons.play_arrow,
            size: 16,
            color: isPaused ? Colors.orange : Colors.green,
          ),
          const Spacer(),
          Text(
            _hour.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
          Text(
            _colonEnable ? ':' : ' ',
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
          Text(
            _minute.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ],
      );
    } catch (e) {
      debugPrint("Error in _GameStatus: $e");
      return const Row(
        children: <Widget>[
          Icon(Icons.games, size: 16, color: Colors.grey),
          Spacer(),
          Text("--:--", style: TextStyle(fontSize: 12)),
        ],
      );
    }
  }
}
