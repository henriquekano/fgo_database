import 'package:flutter/material.dart';
import 'package:fgo_database/loading_cached_image.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchCraftEssences;
import 'package:fgo_database/common/abstractions.dart';

class CraftEssenceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CraftEssencetState();
  }
}

class _CraftEssencetState extends State {
  List<Map<String, dynamic>> _filteredCraftEssences;

  _CraftEssencetState() {
    fetchCraftEssences()
      .then((items) {
        if (this.mounted) {
          setState(() {
            _filteredCraftEssences = items;
          });
        }
      });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Craft Essences'),
    );
  }

  Widget _buildListItem(BuildContext context, Map<String, dynamic> item) {
    final data = item;
    final craftEssenceName = data['name'];
    final craftEssenceIconUrl = data['icon'];

    return ListTile(
      onTap: () => doNothing,
      title: Row(
        children: [
          LoadingCachedImage(
            craftEssenceIconUrl,
            height: 50.0,
            width: 50.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text("$craftEssenceName"),
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
      key: Key('craft_essence_list'),
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
      body: _filteredCraftEssences == null
        ? Center(child: Text('Loading'))
        : _buildBody(context, _filteredCraftEssences),
    );
  }
}

