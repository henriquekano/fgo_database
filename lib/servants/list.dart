import 'package:flutter/material.dart';
import 'package:fgo_database/filter_servant.dart';
import 'details.dart';
import 'package:fgo_database/common/abstractions.dart';
import 'package:fgo_database/common/loading_cached_image.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchServants;
import 'modal_filter.dart';

class ServantList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServantListState();
  }
}

class _ServantListState extends State {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _modalController;
  List<Map<String, dynamic>> _servantDocuments;
  List<Map<String, dynamic>> _filteredServants;
  FilterServants _filterServants;

  @override
  void initState() {
    super.initState();
    fetchServants()
      .then((servants) {
        if (this.mounted) {
          setState(() {
            _servantDocuments = servants;
            _filterServants = FilterServants(servants);
            _filteredServants = servants;
          });
        }
      });
  }

  void _showBottomSheet() {
    _modalController = _scaffoldKey.currentState.showBottomSheet((context) {
      return ModalFilter(_servantDocuments, (filteredServants) {
        setState(() {
          _filteredServants = filteredServants;
        });
        _modalController.close();
      });
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Servants'),
      actions: [
        IconButton(
          onPressed: _filteredServants != null
            ? _showBottomSheet
            : doNothing,
          icon: Icon(Icons.filter_list),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Map<String, dynamic> document) {
    final data = document;
    final servantId = data['status']['id'];
    final servantName = data['name'];
    final List servantIconUrls = data['icons'];

    return ListTile(
      title: Row(
        children: [
          servantIconUrls != null && servantIconUrls.length > 0
            ? LoadingCachedImage(
              servantIconUrls[0],
              height: 50.0,
              width: 50.0,
            )
            : Empty(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text("$servantId - $servantName"),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServantDetails(data),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, List<Map<String, dynamic>> snapshot) {
    snapshot.sort((a, b) {
      final firstId = int.tryParse(a['status']['id']);
      final secondId = int.tryParse(b['status']['id']);
      return firstId.compareTo(secondId);
    });

    final listTiles = snapshot.map((data) {
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
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      body: _filteredServants != null
        ? _buildBody(context, _filteredServants)
        : Center(child: Text('Loading'),),
    );
  }
}
