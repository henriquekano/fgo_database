import 'package:flutter/material.dart';
import 'package:fgo_database/common/loading_cached_image.dart';
import 'package:fgo_database/common/abstractions.dart';
import 'package:fgo_database/common/assets.dart';

typedef String NameExtractor(Map<String, dynamic> document);
typedef String IconExtractor(Map<String, dynamic> document);
typedef void OnTap(Map<String, dynamic> document);

class GenericList extends StatefulWidget {
  final String _pageTitle;
  final NameExtractor _nameExtractor;
  final IconExtractor _iconExtractor;
  final OnTap _onTap;
  final List<dynamic> _filteredDocuments;

  GenericList({
    @required String title,
    @required List<dynamic> filteredDocuments,
    @required NameExtractor nameExtractor,
    @required IconExtractor iconExtractor,
    OnTap onTap,
  }) :
    this._pageTitle = title,
    this._nameExtractor = nameExtractor,
    this._iconExtractor = iconExtractor,
    this._onTap = onTap,
    this._filteredDocuments = filteredDocuments
  ;

  @override
  State<StatefulWidget> createState() {
    return _GenericListState(
      _filteredDocuments,
      _pageTitle,
      _nameExtractor,
      _iconExtractor,
      _onTap,
    );
  }
}

class _GenericListState extends State {
  List<dynamic> _filteredDocuments;
  final NameExtractor _nameExtractor;
  final IconExtractor _iconExtractor;
  final String _pageTitle;
  final OnTap _onTap;

  _GenericListState(
    this._filteredDocuments,
    this._pageTitle,
    this._nameExtractor,
    this._iconExtractor,
    this._onTap,
  );



  Widget _buildListItem(BuildContext context, Map<String, dynamic> item) {
    final data = item;
    final documentName = _nameExtractor(data);
    final documentIcon = _iconExtractor(data);

    return ListTile(
      onTap: _onTap != null
        ? () => _onTap(data)
        : doNothing,
      title: Row(
        children: [
          documentIcon != null
            ? LoadingCachedImage(
                documentIcon,
                height: 50.0,
                width: 50.0,
              )
            : unidentifiedItem,
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text("$documentName"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<dynamic> items) {
    final listTiles = items.map((data) {
      return _buildListItem(context, data);
    }).toList();
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: listTiles,
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context, _filteredDocuments);
  }
}

