import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fgo_database/common/assets.dart'
  show unidentifiedItem;

class LoadingCachedImage extends StatelessWidget {
  final String _url;
  final double _height;
  final double _width;

  LoadingCachedImage(this._url, {
    double height, double width
  })
    : _height = height
    , _width = width
  ;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: unidentifiedItem,
      height: _height,
      width: _width,
      placeholder:
        Container(
          width: _width,
          height: _height,
          child:  Center(
            child: Container(
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      imageUrl: _url,
    );
  }
}