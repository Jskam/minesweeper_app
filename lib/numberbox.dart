import 'package:flutter/material.dart';

class MyNumberBox extends StatelessWidget {
  MyNumberBox({
    Key? key,
    required this.child,
    required this.revealed,
    required this.function,
  }) : super(key: key);

  final child;
  bool revealed;
  final function;

  @override
  Widget build(BuildContext context) {
    final text = revealed
        ? child != 0
            ? child.toString()
            : ''
        : '';
    final Color color = child == 1
        ? Colors.blue
        : child == 2
            ? Colors.green
            : Colors.red;
    return GestureDetector(
      onTap: function,
      child: Container(
        color: revealed ? Colors.grey[300] : Colors.grey[400],
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
