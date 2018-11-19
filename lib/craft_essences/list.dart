import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fgo_database/common/list.dart';
import 'details.dart';
import 'package:fgo_database/common/assets.dart';

class CraftEssenceList extends StatelessWidget {
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('CEs'),
    );
  }

  Widget _buildBodyWithData(BuildContext context, documents) {
    return GenericList(
      title: 'Craft Essences',
      filteredDocuments: documents,
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

  Widget build(BuildContext context) {
    final query = """
      query {
        craft_essences {
          name
          icon
        }
      }
    """;
    return Query(
      query,
      builder: ({bool loading, Map<String, dynamic> data, Exception error}) {
        Widget body = _buildBodyWithData(context, data['craft_essences']);

        if (loading) {
          body = MainLoading();
        }

        if (error != null) {
          body = Center(
            child: errorImage,
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          body: body,
        );
      },
    );
  }
}
