import 'package:flutter/material.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchCraftEssences;
import 'package:fgo_database/common/list.dart';
import 'details.dart';

class CraftEssenceList extends StatelessWidget {
  Widget build(BuildContext context) {
    return GenericList(
      title: 'Craft Essences',
      fetchDocuments: fetchCraftEssences(),
      nameExtractor: (data) => data['name'],
      iconExtractor: (data) => data['icon'],
      onTap: (data) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CraftEssenceDetails(data),
          ),
        );
      },
    );
  }
}
