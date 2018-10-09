import 'package:flutter/material.dart';

class Expand extends StatelessWidget {
  final String _imageUrl;
  Expand(this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.network(_imageUrl),
        ),
      ],
    );
  }
}