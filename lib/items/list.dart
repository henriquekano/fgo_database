import 'package:flutter/material.dart';
import 'details.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchItems;
import 'package:fgo_database/common/list.dart';



class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericList(
      title: 'Items',
      fetchDocuments: fetchItems(),
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
    );
  }
}
