import 'dart:math';

import 'package:flutter/material.dart';

/// Builds an illustration that will be converted into a background-image
/// for the Home Widget. This is never actually shown on-screen in this app.
class HomeWidgetBgImage extends StatelessWidget {
  const HomeWidgetBgImage({super.key, required this.count, this.size, this.color});

  final int count;
  final Size? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        key: ValueKey(count),
        children: _layeredCircles(),
      ),
    );
  }

  List<Widget> _layeredCircles() {
    // Circle widget that is re-used repeatedly below
    final circle = SizedBox(
      width: size?.width ?? 200,
      height: size?.height ?? 200,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CustomPaint(painter: CirclePainter(color: color)),
      ),
    );

    // Build a list of rotated images 1...count
    final double alphaStep = 1 / count; // Circles fade out as they go further back
    final double rotationStep = -(2 * pi) / count; // Rotations angles are distributed evenly across all circles
    return List.generate(
      count,
      (index) {
        // Rotate and fade all circles except for the first
        if (index == 0) return circle;
        return Transform.rotate(
          angle: rotationStep * index,
          child: Opacity(
            opacity: 1 - alphaStep * index,
            child: circle,
          ),
        );
      },
    );
  }
}

// Draws a white circle outline. Top-center aligned, with some extra space at the bottom.
// By drawing the circle off-center vertically, it will create a nice effect when rotated around the center point.
class CirclePainter extends CustomPainter {
  CirclePainter({required this.color});

  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color ?? Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    const heightFactor = .82;
    final circleSize = size.height * heightFactor;
    final center = Offset(size.width / 2, circleSize / 2);
    canvas.drawCircle(center, circleSize / 2 - paint.strokeWidth, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
