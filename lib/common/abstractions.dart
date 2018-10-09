import 'package:flutter/material.dart';
import 'assets.dart'
  show errorImage;
import 'device.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

class PageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('So sorry about it, but...'),
          Container(
            height: deviceHeight(context) / 2,
            child: errorImage,
          ),
        ],
      ),
    );
  }
}

final doNothing = () => null;