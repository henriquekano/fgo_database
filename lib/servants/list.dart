import 'package:flutter/material.dart';
import 'package:fgo_database/filter_servant.dart';
import 'details.dart';
import 'package:fgo_database/common/abstractions.dart';
import 'package:fgo_database/loading_cached_image.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchServants;
import 'package:fgo_database/common/assets.dart';

class ModalFilter extends StatefulWidget {
  ModalFilter(this._allServants, this._closeCallback);

  final _closeCallback;
  final List<Map<String, dynamic>> _allServants;
  @override
  State<StatefulWidget> createState() {
    return _ModalFilterState(this._allServants, this._closeCallback);
  }
}

class _ModalFilterState extends State<ModalFilter> {
  _ModalFilterState(
    List<Map<String, dynamic>> servants,
    this._closeCallback
  ) {
    this._filterServants = FilterServants(servants);
  }
  FilterServants _filterServants;
  final _closeCallback;
  final Map<String, dynamic> _filter = {
    'name': null,
    'class': {
      'assassin': false,
      'archer': false,
      'avenger': false,
      'berserker': false,
      'caster': false,
      'foreigner': false,
      'lancer': false,
      'mooncancer': false,
      'rider': false,
      'ruler': false,
      'saber': false,
      'shielder': false,
    }
  };

  Widget __selectableClassIcon(Widget icon, String clazz) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter['class'][clazz] =
            !_filter['class'][clazz];
        });
      },
      child: Opacity(
        opacity: _filter['class'][clazz] ? 1.0 : 0.4,
        child: icon,
      ),
    );
  }

  Widget _buildClassFilterSection() {
    return Column(
      children: [
      Text('CLASS'),
        Wrap(
          children: [
            __selectableClassIcon(avengerClass, 'avenger'),
            __selectableClassIcon(assassinClass, 'assassin'),
            __selectableClassIcon(archerClass, 'archer'),
            __selectableClassIcon(casterClass, 'caster'),
            __selectableClassIcon(berserkerClass, 'berserker'),
            __selectableClassIcon(foreignerClass, 'foreigner'),
            __selectableClassIcon(lancerClass, 'lancer'),
            __selectableClassIcon(mooncancerClass, 'mooncancer'),
            __selectableClassIcon(riderClass, 'rider'),
            __selectableClassIcon(rulerClass, 'ruler'),
            __selectableClassIcon(saberClass, 'saber'),
            __selectableClassIcon(shielderClass, 'shielder'),
          ],
        ),
      ],
    );
  }

  Widget _buildNameFilterSection() {
    return Column(
      children: [
        Text('NAME'),
        TextField(
          controller: TextEditingController(text: _filter['name'],),
          onChanged: (name) {
            _filter['name'] = name;
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final classFilter = (_filter['class'] as Map<String, bool>);
    final classFilterNames = classFilter
      .keys
      .where((className) =>
        classFilter[className]
      )
      .toList();
    return Container(
      padding: EdgeInsets.all(10.0),
      child:  Column(
        children: [
          _buildNameFilterSection(),
          _buildClassFilterSection(),
          RaisedButton(
            onPressed: () {
              this._closeCallback(
                _filterServants
                  .setNameFilter(_filter['name'])
                  .setClasses(classFilterNames)
                  .filter()
              );
            },
            child: Text('Filter'),
          ),
        ],
      ),
    );
    // TODO: implement build
  }
}

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
