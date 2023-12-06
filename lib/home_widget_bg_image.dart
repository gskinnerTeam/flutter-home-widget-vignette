
import 'package:flutter/material.dart';

class HomeWidgetBgImage extends StatelessWidget {
  const HomeWidgetBgImage({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.pinkAccent,
        alignment: Alignment.center,
        child: Text('$count', style: const TextStyle(fontSize: 24),),);
  }
}