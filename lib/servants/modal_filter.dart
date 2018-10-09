import 'package:flutter/material.dart';
import 'package:fgo_database/common/assets.dart';
import 'package:fgo_database/filter_servant.dart';

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
