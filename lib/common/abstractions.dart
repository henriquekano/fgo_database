import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

final doNothing = () => null;