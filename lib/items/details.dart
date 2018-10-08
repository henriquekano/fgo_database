import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:fgo_database/loading_cached_image.dart';
import 'package:fgo_database/common/abstractions.dart';

class ItemDetails extends StatefulWidget {
  final Map<String, dynamic> _details;

  ItemDetails(this._details);

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailsState(this._details);
  }
}

class _ItemDetailsState extends State<ItemDetails> {
  final Map<String, dynamic> _details;
  final List<DocumentSnapshot> _skillEnhancedServants = [];
  _ItemDetailsState(this._details);

  @override
  void initState() {
    super.initState();
    if (_details.containsKey('servant_skill_upgrade')) {
      _fetchSkillEnhanhementServants();
    }
  }

  _fetchSkillEnhanhementServants() {
    final List servantIds = _details['servant_skill_upgrade'];

    Firestore.instance.collection('servants').getDocuments()
      .then((documents) {
        if (this.mounted) {
          final filteredServant = documents.documents.where((doc) =>
            servantIds.contains(doc.documentID)
          );
          setState(() {
            _skillEnhancedServants.addAll(filteredServant);
          });
        }
      });
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(_details['name']),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 90.0,
          height: 90.0,
          child: LoadingCachedImage(_details['image']),
        ),
        Expanded(
          child: Text(_details['description']),
        ),
      ],
    );
  }

  int __sumTotalAmountNecessary(Map<String, dynamic> servantData) {
    final skillEnhancementsReq = servantData['skill_enhancement_materials'];
    final Iterable quantityPerLevel = skillEnhancementsReq.map((req) {
      final List materials = req['materials'];
      return materials
        .firstWhere(
          (mat) => mat['item_id'] == _details['id'],
          orElse: () => { 'quantity': 0 }
        )['quantity'];
    });

    return quantityPerLevel
      .fold(0, (acc, current) {
        return acc + current;
      });
  }

  Widget _buildSkillEnhancementSection(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return StickyHeader(
      header: Container(
        height: 50.0,
        color: Colors.grey,
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: new Text(
          'Skill enhancement of',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: _skillEnhancedServants.length == 0
        ? CircularProgressIndicator()
        : Wrap(
          children: _skillEnhancedServants.map((servant) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Column(
                children: [
                  Container(
                    height: deviceWidth / 5,
                    width: deviceWidth / 5,
                    child: servant.data.containsKey('icons')
                      ? LoadingCachedImage(servant.data['icons'][0])
                      : Text('${servant.data["name"]}'),
                  ),
                  Text('Total: ' + __sumTotalAmountNecessary(servant.data).toString(),
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
        ),
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: _buildAppBar(),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _details.containsKey('servant_skill_upgrade')
                ? _buildSkillEnhancementSection(context)
                : Empty(),
            ],
          ),
        ),
      ),
    );
    }
}