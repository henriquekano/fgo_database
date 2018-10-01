import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoadingCachedImage extends StatelessWidget {
  final String _url;
  double _height;
  double _width;

  LoadingCachedImage(this._url, {
    double height, double width
  }) : super() {
    this._width = width;
    this._height = height;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: _height,
      width: _width,
      placeholder: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
      imageUrl: _url,
    );
  }
}