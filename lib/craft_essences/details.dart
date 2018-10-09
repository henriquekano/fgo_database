import 'package:flutter/material.dart';
import 'package:fgo_database/common/loading_cached_image.dart';
import 'package:fgo_database/common/expand.dart';
import 'package:fgo_database/common/transition.dart';

class CraftEssenceDetails extends StatelessWidget {
  final Map<String, dynamic> _details;
  CraftEssenceDetails(this._details);

  Widget _buildAppBar() {
    return AppBar(
      title: Text(_details['name']),
    );
  }

  @override
    Widget build(BuildContext context) {
      final fullImageUrl = _details['full_image'];
      final Widget image = LoadingCachedImage(
        fullImageUrl,
        height: 300.0,
        width: 100.0,
      );
      return Scaffold(
        appBar: _buildAppBar(),
        body: Material(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  child: image,
                  onLongPress: () {
                    Navigator.push(
                      context,
                      ZoomTransition(
                        builder: (context) => Expand(fullImageUrl),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
}