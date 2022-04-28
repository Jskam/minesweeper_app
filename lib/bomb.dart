import 'package:flutter/material.dart';

class MyBomb extends StatelessWidget {
  MyBomb({
    Key? key,
    required this.revealed,
    required this.function,
  }) : super(key: key);

  bool revealed;
  final function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        color: revealed ? Colors.grey[800] : Colors.grey[400],
      ),
    );
  }
}
