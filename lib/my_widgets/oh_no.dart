import 'package:flutter/material.dart';

class OhNo extends StatelessWidget {
  final String text;

  OhNo({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        color: Colors.pink[50],
        child: Text(
          'Oh no${text.isEmpty ? '!' : ': $text!'}',
          style: TextStyle(color: Colors.red[700], fontSize: 24.0),
        ));
  }
}
