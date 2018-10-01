import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fgo_database/loading_cached_image.dart';
import 'details.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchItems;

class ItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemListState();
  }
}

class _ItemListState extends State {
  List<Map<String, dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    fetchItems()
      .then((items) {
        if (this.mounted) {
          setState(() {
            _filteredItems = items;
          });
        }
      });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Items'),
    );
  }

  Widget _buildListItem(BuildContext context, Map<String, dynamic> item) {
    final data = item;
    final itemName = data['name'];
    final itemIconUrl = data['image'];

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetails(data),
        ),
      ),
      title: Row(
        children: [
          LoadingCachedImage(
            itemIconUrl,
            height: 50.0,
            width: 50.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text("$itemName"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Map<String, dynamic>> items) {
    final listTiles = items.map((data) {
      return _buildListItem(context, data);
    }).toList();
    return ListView(
      key: Key('servants_list'),
      children: ListTile.divideTiles(
        context: context,
        tiles: listTiles,
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _filteredItems == null
        ? Center(child: Text('Loading'))
        : _buildBody(context, _filteredItems),
    );
  }
}

