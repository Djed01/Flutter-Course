import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text,{Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:const TextStyle(color: Colors.white, fontSize: 28),
    );
  }
}