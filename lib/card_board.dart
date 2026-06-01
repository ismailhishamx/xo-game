import 'package:flutter/material.dart';

class CardBoard extends StatelessWidget {
  final String text;
  final int index;
  final Function onButtonCall;

  const CardBoard({super.key, required this.text, required this.index, required this.onButtonCall});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = text == 'X' ? Colors.red : text == 'O' ? Colors.blue : Colors.grey[850]!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonCall(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}