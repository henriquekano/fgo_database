import 'package:flutter/material.dart';
import 'details.dart';
import 'package:fgo_database/common/list.dart';

class ItemList extends StatelessWidget {
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Items'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GenericList(
        title: 'Items',
        filteredDocuments: [],
        iconExtractor: (data) => data['image'],
        nameExtractor: (data) => data['name'],
        onTap: (data) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetails(data),
            ),
          );
        }
      ),
    );
  }
}
