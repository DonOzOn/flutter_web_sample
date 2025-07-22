import 'package:flutter/material.dart';

const colorNormal = Colors.black87;
const colorNull = Colors.black12;
const colorHighlight = Color(0xFF560000);

class BrickSize extends InheritedWidget {
  const BrickSize({
    super.key,
    required this.size,
    required super.child,
  });

  final Size size;

  static BrickSize? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BrickSize>();
  }

  @override
  bool updateShouldNotify(BrickSize oldWidget) {
    return oldWidget.size != size;
  }
}

///the basic brick for game panel
class Brick extends StatelessWidget {
  final Color color;

  const Brick._({super.key, required this.color});

  const Brick.normal({Key? key}) : this._(color: colorNormal, key: key);

  const Brick.empty({Key? key}) : this._(color: colorNull, key: key);

  const Brick.highlight({Key? key}) : this._(color: colorHighlight, key: key);

  @override
  Widget build(BuildContext context) {
    final brickSize = BrickSize.of(context);
    final size = brickSize?.size ?? const Size(16, 16); // Minimum fallback size
    final width = size.width;
    
    // Calculate margins and borders that work for small sizes
    final margin = width > 8 ? width * 0.05 : 0.5;
    final padding = width > 8 ? width * 0.05 : 0.5;
    final borderWidth = width > 10 ? width * 0.08 : 1.0;
    
    debugPrint("Brick: size=$size, margin=$margin, padding=$padding, borderWidth=$borderWidth");
    
    return SizedBox.fromSize(
      size: size,
      child: Container(
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          border: Border.all(width: borderWidth, color: color),
          color: color == colorNull ? Colors.transparent : color.withOpacity(0.8),
        ),
        child: Container(
          margin: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color == colorNull ? Colors.transparent : color,
            boxShadow: color != colorNull ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ] : null,
          ),
        ),
      ),
    );
  }
}
