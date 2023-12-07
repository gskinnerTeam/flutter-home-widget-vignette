import 'dart:math';

import 'package:flutter/material.dart';

class HomeWidgetBgImage extends StatelessWidget {
  const HomeWidgetBgImage({super.key, required this.count, this.size});

  final int count;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Stack(children: _layeredCircles()),
      ),
    );
  }

  List<Widget> _layeredCircles() {
    final circle = Image.asset('assets/images/starter-shape.png', fit: BoxFit.contain);

    Widget buildRotatedCircle(int value) {
      final double alphaStep = 1 / count;
      final double rotationStep = (2 * pi) / count;
      value -= 1;
      return Transform.rotate(
        angle: rotationStep * value,
        child: Opacity(opacity: 1 - alphaStep * value, child: circle),
      );
    }

    return [
      circle,
      ...List.generate(
        count,
        (index) {
          return buildRotatedCircle(index + 1);
        },
      )
    ];
  }
}
