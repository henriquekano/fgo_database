import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart'
  show parse;
import 'package:html/dom.dart'
  show Document;
import 'package:fgo_database/common/abstractions.dart';

final jpEmoji = '🇯🇵';
final usEmoji = '🇺🇸';
final appBar = AppBar(
  title: Text('News'),
  bottom: TabBar(
    tabs: [
      Tab(
        icon: Text(usEmoji),
      ),
      Tab(
        icon: Text(jpEmoji),
      ),
    ],
  ),
);

class _NewsPageParsedState extends State<NewsPageParsed> {
  final List<Map<String, dynamic>> _news = List();
  String _nextPageUrl;
  String _url;
  final _httpRequester = Dio();
  bool _requestingMore = true;

  _NewsPageParsedState(this._url) {
    _nextPageUrl = this._url;
  }

  String __prependZeroToMonth(String number) {
    if (number.length == 1) {
      return '0${number}';
    }
    return number;
  }

  Iterable<Map<String, dynamic>> _parseNewsPage(Document htmlDocument) {
    final newsLinks = htmlDocument.querySelectorAll('a.clearfix');
    return newsLinks.map((news) {
      final detailsLink = news.attributes['href'];
      final date = news.querySelector('.date').text.replaceAll(RegExp('[^0-9]\$'), '');
      final splittedDate = date.split(RegExp('[^0-9]'));
      final parsedDate = DateTime.parse('${detailsLink.substring(1, 5)}${__prependZeroToMonth(splittedDate[0])}${__prependZeroToMonth(splittedDate[1])}');
      final title = news.querySelector('.title').text;
      return {
        'date': parsedDate,
        'title': title,
        'link': _url + detailsLink,
      };
    });
  }

  String _parseNextPageLink(Document htmlDocument) {
    try {
      return _url + htmlDocument
        .querySelector('.page-btn-box a.next').attributes['href'];
    } on NoSuchMethodError {
      return null;
    }
  }

  void _fetchMoreNews() {
    if (this.mounted && _nextPageUrl != null) {
      setState(() {
        _requestingMore = true;
        _httpRequester.get(_nextPageUrl)
          .then((res) => res.data)
          .then(parse)
          .then((htmlDocument) {
            this._nextPageUrl = _parseNextPageLink(htmlDocument);
            return htmlDocument;
          })
          .then(_parseNewsPage)
          .then((newNews) {
            if (this.mounted) {
              setState(() {
                _requestingMore = false;
                _news.addAll(newNews);
              });
            }
          })
          .catchError((err) {
            Scaffold.of(this.context).showSnackBar(
              SnackBar(
                content: Text('Couldn\'t get more :('),
              ),
            );
          });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMoreNews();
  }

  Widget _buildListTile(BuildContext context,  Map<String, dynamic> content) {
    final DateTime date = content['date'];
    final String title = content['title'];
    final String detailsUrl = content['link'];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetails(detailsUrl),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child:  ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.year}/${date.month}/${date.day}',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(children: [
                Text(title),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _news.map((content) => _buildListTile(context, content));
    final scrollController = ScrollController();
    scrollController.addListener(() {
      final reachedBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
      if (reachedBottom && !_requestingMore) {
        _fetchMoreNews();
      }
    });
    final list = ListView(
      controller: scrollController,
      children: ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList()
    );

    return DefaultTabController(
      length: 2,
      child: _news.length != 0
        ? Column(
          children: [
            Expanded(
              child: list,
            ),
            _requestingMore ? CircularProgressIndicator() : Empty(),
          ],
        )
      : Center(child: Text('Loading')),
    );
  }
}

class NewsPageParsed extends StatefulWidget {
  final _url;
  NewsPageParsed(this._url);

  @override
  State<StatefulWidget> createState() {
    return _NewsPageParsedState(_url);
  }
}

class NewsDetails extends StatefulWidget {
  final String _url;
  NewsDetails(this._url);

  @override
  State<StatefulWidget> createState() {
    return _NewsDetailsState(_url);
  }
}

class _NewsDetailsState extends State<NewsDetails> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  final _url;
  _NewsDetailsState(this._url);

  @override
  void dispose() {
    _flutterWebviewPlugin.close();
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thisAppBar = AppBar(
      title: Text('News'),
    );
    _flutterWebviewPlugin.launch(
      _url,
      rect: Rect.fromLTWH(
        0.0,
        thisAppBar.preferredSize.height * 1.4,//wat
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height, //hack: this hides the back button in the news page
      ),
    );
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: thisAppBar,
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            NewsPageParsed('https://webview.fate-go.us'),
            NewsPageParsed('https://webview.fate-go.jp'),
          ],
        ),
      ),
    );
  }
}
