import 'package:flutter/material.dart';
import 'servants/list.dart';
import 'news.dart';
import 'items/list.dart';
import 'craft_essences/list.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final tabBar = TabBar(
  isScrollable: false,
  labelColor: Colors.white,
  unselectedLabelColor: Colors.black,
  indicatorColor: Colors.white,
  tabs: [
    Tab(
      text: 'News',
      icon: Icon(Icons.new_releases),
    ),
    Tab(
      text: 'Servants',
      icon: Icon(Icons.security),
    ),
    Tab(
      text: 'Items',
      icon: Icon(Icons.widgets),
    ),
    Tab(
      text: 'CEs',
      icon: Icon(Icons.style),
    ),
  ],
);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = ValueNotifier(
      Client(
        endPoint: 'http://fgo-database-api.herokuapp.com/graphql',
        cache: InMemoryCache(),
      ),
    );
    return GraphqlProvider(
      client: client,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: DefaultTabController(
          length: tabBar.tabs.length,
          child: Scaffold(
            backgroundColor: Colors.indigo,
            bottomNavigationBar: tabBar,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                NewsPage(),
                ServantList(),
                ItemList(),
                CraftEssenceList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
