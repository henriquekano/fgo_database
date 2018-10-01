import 'package:flutter/material.dart';
import 'servants/list.dart';
import 'news.dart';
import 'items/list.dart';

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
  ],
);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
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
            ],
          ),
        ),
      ),
    );
  }
}
