import 'package:flutter/material.dart';

class ConfidenceBar extends StatelessWidget {
  final double value;
  const ConfidenceBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: 10,
      backgroundColor: Colors.grey.shade300,
      color: value > 0.7 ? Colors.green : Colors.orange,
    );
  }
}
