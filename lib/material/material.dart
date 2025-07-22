import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GameMaterial extends StatefulWidget {
  final Widget child;

  const GameMaterial({super.key, required this.child});

  @override
  State<GameMaterial> createState() => _GameMaterialState();

  static ui.Image? getMaterial(BuildContext context) {
    final state = context.findAncestorStateOfType<_GameMaterialState>();
    return state?.material;
  }
}

class _GameMaterialState extends State<GameMaterial> {
  ///the image data of /assets/material.png
  ui.Image? material;

  @override
  void initState() {
    super.initState();
    _createFallbackMaterial();
  }

  void _createFallbackMaterial() async {
    // Create a simple fallback material programmatically
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    // Create a simple sprite sheet with numbers and basic patterns
    const size = 300.0;

    // Background
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size, size), paint);

    // Draw simple digit patterns for 0-9
    paint.color = Colors.white;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 10; i++) {
      textPainter.text = TextSpan(
        text: i.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(75.0 + (i * 14.0), 25.0));
    }

    // Draw simple icons
    paint.color = Colors.green;
    canvas.drawRect(
      const Rect.fromLTWH(75, 75, 20, 18),
      paint,
    ); // pause icon area

    paint.color = Colors.blue;
    canvas.drawRect(
      const Rect.fromLTWH(100, 75, 20, 18),
      paint,
    ); // play icon area

    // Draw dragon/tetris logo area
    paint.color = Colors.red;
    for (int frame = 0; frame < 4; frame++) {
      canvas.drawRect(Rect.fromLTWH(frame * 100.0, 100.0, 80.0, 86.0), paint);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());

    if (mounted) {
      setState(() {
        material = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return material == null ? Container() : widget.child;
  }
}
