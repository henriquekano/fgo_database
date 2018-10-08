import 'package:flutter/material.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchCraftEssences;
import 'package:fgo_database/common/list.dart';

class CraftEssenceList extends StatelessWidget {
  Widget build(BuildContext context) {
    return GenericList(
      title: 'Craft Essences',
      fetchDocuments: fetchCraftEssences(),
      nameExtractor: (data) => data['name'],
      iconExtractor: (data) => data['icon'],
    );
  }
}
