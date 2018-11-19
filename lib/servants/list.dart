import 'package:flutter/material.dart';
import 'details.dart';
import 'package:fgo_database/common/list.dart';
import 'package:fgo_database/common/assets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ServantList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ServantListState();
  }
}

class _ServantListState extends State {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchServants()
  //     .then((servants) {
  //       if (this.mounted) {
  //         setState(() {
  //           _servantDocuments = servants;
  //           _filterServants = FilterServants(servants);
  //           _filteredServants = servants;
  //         });
  //       }
  //     });
  // }

  // void _showBottomSheet() {
  //   _modalController = _scaffoldKey.currentState.showBottomSheet((context) {
  //     return ModalFilter(_servantDocuments, (filteredServants) {
  //       setState(() {
  //         _filteredServants = filteredServants;
  //       });
  //       _modalController.close();
  //     });
  //   });
  // }

  // AppBar _buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: Text('Servants'),
  //     actions: [
  //       IconButton(
  //         onPressed: _filteredServants != null
  //           ? _showBottomSheet
  //           : doNothing,
  //         icon: Icon(Icons.filter_list),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildListItem(BuildContext context, Map<String, dynamic> document) {
  //   final data = document;
  //   final servantId = data['status']['id'];
  //   final servantName = data['name'];
  //   final List servantIconUrls = data['icons'];

  //   return ListTile(
  //     title: Row(
  //       children: [
  //         servantIconUrls != null && servantIconUrls.length > 0
  //           ? LoadingCachedImage(
  //             servantIconUrls[0],
  //             height: 50.0,
  //             width: 50.0,
  //           )
  //           : Empty(),
  //         Expanded(
  //           child: Container(
  //             margin: EdgeInsets.only(left: 10.0),
  //             child: Text("$servantId - $servantName"),
  //           ),
  //         ),
  //       ],
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ServantDetails(data),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildBody(BuildContext context, List<Map<String, dynamic>> snapshot) {
  //   snapshot.sort((a, b) {
  //     final firstId = int.tryParse(a['status']['id']);
  //     final secondId = int.tryParse(b['status']['id']);
  //     return firstId.compareTo(secondId);
  //   });

  //   final listTiles = snapshot.map((data) {
  //     return _buildListItem(context, data);
  //   }).toList();
  //   return ListView(
  //     key: Key('servants_list'),
  //     children: ListTile.divideTiles(
  //       context: context,
  //       tiles: listTiles,
  //     ).toList(),
  //   );
  // }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Servants'),
    );
  }

  Widget _buildBodyWithData(BuildContext context, data) {
    return GenericList(
      title: 'Servants',
      filteredDocuments: data,
      iconExtractor: (doc) {
        final iconUrls = doc['icons'];
        final hasIcon = iconUrls != null && iconUrls.length > 0;
        return hasIcon ? iconUrls[0] : null;
      },
      nameExtractor: (doc) => doc['name'],
      onTap: (doc) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServantDetails(doc),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final servantsQuery = """
      query {
        servants {
          name
          icons
          _id
        }
      }
    """;
    return Query(
      servantsQuery,
      builder: ({bool loading, Map<String, dynamic> data, Exception error}) {
        Widget body = _buildBodyWithData(context, data['servants']);
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
