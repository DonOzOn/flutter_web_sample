import 'package:flutter/material.dart';
import 'package:miniapp_web/material/briks.dart';
import 'package:miniapp_web/material/images.dart';
import 'package:miniapp_web/gamer/gamer.dart';

const playerPanelPadding = 6;

Size getBrikSizeForScreenWidth(double width) {
  final size = (width - playerPanelPadding) / gamePadMatrixW;
  debugPrint("Calculated brick size: $size for width: $width");
  return Size.square(size);
}

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({super.key, required double width})
    : assert(width != 0),
      size = Size(width, width * 2);

  @override
  Widget build(BuildContext context) {
    debugPrint("PlayerPanel build - size: $size");
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Stack(children: <Widget>[_PlayerPad(), _GameUninitialized()]),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("_PlayerPad build started");

    try {
      final gameState = GameState.of(context);
      debugPrint("Game data rows: ${gameState.data.length}");
      debugPrint("Game state: ${gameState.states}");

      if (gameState.data.isEmpty) {
        debugPrint("Game data is empty, creating fallback");
        return _createFallbackGrid();
      }

      return Column(
        children:
            gameState.data.asMap().entries.map((entry) {
              final rowIndex = entry.key;
              final list = entry.value;
              if (list.isEmpty) {
                debugPrint("Row $rowIndex is empty");
                return Container();
              }
              return Row(
                children:
                    list.asMap().entries.map((colEntry) {
                      final colIndex = colEntry.key;
                      final b = colEntry.value;

                      Widget brick;
                      if (b == 1) {
                        brick = const Brick.normal();
                      } else if (b == 2) {
                        brick = const Brick.highlight();
                      } else {
                        brick = const Brick.empty();
                      }

                      return brick;
                    }).toList(),
              );
            }).toList(),
      );
    } catch (e) {
      debugPrint("Error in _PlayerPad: $e");
      return _createFallbackGrid();
    }
  }

  Widget _createFallbackGrid() {
    debugPrint("Creating fallback grid: ${gamePadMatrixH}x${gamePadMatrixW}");
    return Column(
      children: List.generate(gamePadMatrixH, (row) {
        return Row(
          children: List.generate(gamePadMatrixW, (col) {
            return const Brick.empty();
          }),
        );
      }),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("_GameUninitialized build started");

    try {
      final gameState = GameState.of(context);
      debugPrint("Game state in uninitialized: ${gameState.states}");

      if (gameState.states == GameStates.none) {
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.games, size: 60, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  "TETRIS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Press SPACE or tap DROP to start! Don",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  "Use arrow keys to move pieces Don",
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(); // Game is running, show the grid
      }
    } catch (e) {
      debugPrint("Error in _GameUninitialized: $e");
      // Fallback content when there's an error
      return Container(
        color: Colors.black.withOpacity(0.7),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.games, size: 60, color: Colors.white),
              SizedBox(height: 16),
              Text(
                "TETRIS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Press SPACE or tap DROP to start!",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }
  }
}
