import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart'
  show Vector3;
import 'package:flutter_swiper/flutter_swiper.dart'
    show Swiper, SwiperPagination;
import 'package:fgo_database/loading_cached_image.dart';
import 'package:fgo_database/empty.dart';
import 'package:fgo_database/fgo_database_service.dart'
  show fetchActiveSkills, fetchClassSkills;

final quickIcon = Image.asset('assets/quick.png');
final busterIcon = Image.asset('assets/buster.png');
final artsIcon = Image.asset('assets/arts.png');
final assassinClass = Image.asset(
  'assets/assassin.png',
  width: 40.0,
  height: 40.0,
);
final archerClass = Image.asset(
  'assets/archer.png',
  width: 40.0,
  height: 40.0,
);
final avengerClass = Image.asset(
  'assets/avenger.png',
  width: 40.0,
  height: 40.0,
);
final berserkerClass = Image.asset(
  'assets/berserker.png',
  width: 40.0,
  height: 40.0,
);
final casterClass = Image.asset(
  'assets/caster.png',
  width: 40.0,
  height: 40.0,
);
final foreignerClass = Image.asset(
  'assets/foreigner.png',
  width: 40.0,
  height: 40.0,
);
final lancerClass = Image.asset(
  'assets/lancer.png',
  width: 40.0,
  height: 40.0,
);
final mooncancerClass = Image.asset(
  'assets/mooncancer.png',
  width: 40.0,
  height: 40.0,
);
final riderClass = Image.asset(
  'assets/rider.png',
  width: 40.0,
  height: 40.0,
);
final rulerClass = Image.asset(
  'assets/ruler.png',
  width: 40.0,
  height: 40.0,
);
final saberClass = Image.asset(
  'assets/saber.png',
  width: 40.0,
  height: 40.0,
);
final shielderClass = Image.asset(
  'assets/shielder.png',
  width: 40.0,
  height: 40.0,
);

class Expand extends StatelessWidget {
  final Widget thigToExpand;
  Expand(this.thigToExpand);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: GestureDetector(
            child: Transform(
              transform: Matrix4.diagonal3(Vector3(1.1, 1.1, 1.1)),
              alignment: FractionalOffset.center,
              child: thigToExpand,
            ),
          ),
        ),
      ],
    );
  }
}

class ZoomTransition extends MaterialPageRoute {
  ZoomTransition({WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class ServantDetails extends StatefulWidget {
  final Map<String, dynamic> _details;

  ServantDetails(this._details);

  @override
  State<StatefulWidget> createState() {
    return _ServantDetailsState(this._details);
  }
}

class _ServantDetailsState extends State<ServantDetails> {
  final Map<String, dynamic> _details;
  List<Map<String, dynamic>> _activeSKills;
  List<Map<String, dynamic>> _classSkills;
  var _showImage = 0;
  var _navigationBottomIndex = 0;
  _ServantDetailsState(this._details);

  @override
  void initState() {
    super.initState();
    fetchActiveSkills(servantId: _details['_id'])
      .then((activeSkills) {
        if (this.mounted) {
          setState(() {
            _activeSKills = activeSkills;
          });
        }
      });
    fetchClassSkills(servantId: _details['_id'])
      .then((classSkills) {
        if (this.mounted) {
          setState(() {
            _classSkills = classSkills;
          });
        }
      });
  }

  AppBar _buildAppBar() {
    final String name = _details['name'];
    return AppBar(
      title: Text(name),
    );
  }

  Widget __section(String sectionName, List<Widget> children) {
    final List<Widget> finalChildren = [
      Text(
        sectionName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
    finalChildren.addAll(children);

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: finalChildren,
        ),
      ),
    );
  }

  Widget __swiper(List imagesUrls) {
    final imageBuilder = (context, index) {
      final image = LoadingCachedImage(imagesUrls[index]);

      return Container(
        padding: EdgeInsets.only(
          bottom: 40.0,
          top: 20.0,
        ),
        child: GestureDetector(
          child: image,
          onLongPress: () {
            Navigator.push(
              context,
              ZoomTransition(
                builder: (context) => Expand(image),
              ),
            );
          },
        ),
      );
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Center(
        child: Swiper(
          loop: false,
          scale: 0.8,
          viewportFraction: 0.5,
          itemCount: List.from(imagesUrls).length,
          itemBuilder: imageBuilder,
          pagination: SwiperPagination(),
        ),
      ),
    );
  }

  Widget _ascensions() {
    final ascentionImages = _details['ascensions'];
    return __swiper(ascentionImages);
  }

  Widget _sprites() {
    final sprites = _details['sprites'];
    return __swiper(sprites);
  }

  _toggleImagesCreator(int index) {
    return () => setState(() {
      _showImage = index;
    });
  }

  Widget _class() {
    final String servantClass = _details['status']['class'];
    var classImage = shielderClass;
    switch (servantClass.toLowerCase()) {
      case 'assassin':
        classImage = assassinClass;
        break;
      case 'archer':
        classImage = archerClass;
        break;
      case 'avenger':
        classImage = avengerClass;
        break;
      case 'berserker':
        classImage = berserkerClass;
        break;
      case 'caster':
        classImage = casterClass;
        break;
      case 'foreigner':
        classImage = foreignerClass;
        break;
      case 'lancer':
        classImage = lancerClass;
        break;
      case 'mooncancer':
        classImage = mooncancerClass;
        break;
      case 'rider':
        classImage = riderClass;
        break;
      case 'ruler':
        classImage = rulerClass;
        break;
      case 'saber':
        classImage = saberClass;
        break;
      case 'shielder':
        classImage = shielderClass;
        break;
    }

    return __section('CLASS', [classImage]);
  }

  Widget _deck() {
    final deckDetails = _details['deck'];

    final List<Image> deck = [];
    for (int i = 0; i < deckDetails['arts']; i++) {
      deck.add(artsIcon);
    }
    for (int i = 0; i < deckDetails['buster']; i++) {
      deck.add(busterIcon);
    }
    for (int i = 0; i < deckDetails['quick']; i++) {
      deck.add(quickIcon);
    }

    return __section('DECK', [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: deck,
      ),
    ]);
  }

  Widget _status() {
    final status = _details['status'];
    return __section('STATUS', [
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(),
              children: [
                Text('LVL'),
                Text('ATK'),
                Text('HP'),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(),
              children: [
                Text('base'),
                Text(status['base_atk']),
                Text(status['base_hp']),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(),
              children: [
                Text('max'),
                Text(status['max_atk']),
                Text(status['max_hp']),
              ],
            ),
            TableRow(
              decoration: BoxDecoration(),
              children: [
                Text('grail'),
                Text(status['grail_atk']),
                Text(status['grail_hp']),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _traits() {
    final List<dynamic> traitList = _details['advanced_info']['traits'];
    return __section('TRAITS', [
      Wrap(
        children: traitList
            .map(
              (trait) => FilterChip(
                    label: Text(trait.toString()),
                    onSelected: (boolean) {},
                  ),
            )
            .toList(),
      ),
    ]);
  }

  Widget __buildSkillBox(skillObject) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LoadingCachedImage(skillObject['image']),
              Expanded(
                child: Text(skillObject['name']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget __buildActiveSkillBox(activeSkill) {
    return __buildSkillBox(activeSkill);
  }

  Widget _activeSkills() {
    final List<Widget> skillBoxes =
      _activeSKills.map(__buildActiveSkillBox).toList();

    return __section('ACTIVE SKILLS', skillBoxes);
  }

  Widget _buildClassSkills() {
    final List<Widget> skillBoxes = _classSkills.map(__buildSkillBox).toList();

    return __section('PASSIVE SKILLS', skillBoxes);
  }

  Widget _advanced() {
    final advancedInfo = _details['advanced_info'];
    return __section('OTHERS', [
      Table(
        defaultColumnWidth: FractionColumnWidth(0.6),
        children: [
          TableRow(
            children: [
              Text('STAR GENERATION'),
              Text(advancedInfo['stars']['generation']),
            ],
          ),
          TableRow(
            children: [
              Text('STAR ABSORPTION'),
              Text(advancedInfo['stars']['absorption']),
            ],
          ),
          TableRow(
            children: [
              Text('NP ATTACK CHARGE'),
              Text(advancedInfo['noble_phantasm']['charge']),
            ],
          ),
          TableRow(
            children: [
              Text('NP DEFFENCE CHARGE'),
              Text(advancedInfo['noble_phantasm']['attacked']),
            ],
          ),
          TableRow(
            children: [
              Text('INSTANT DEATH'),
              Text(advancedInfo['instant_death']),
            ],
          ),
          TableRow(
            children: [
              Text('ARTS # HITS'),
              Text(advancedInfo['number_of_hits']['arts']),
            ],
          ),
          TableRow(
            children: [
              Text('BUSTER # HITS'),
              Text(advancedInfo['number_of_hits']['buster']),
            ],
          ),
          TableRow(
            children: [
              Text('QUICK # HITS'),
              Text(advancedInfo['number_of_hits']['quick']),
            ],
          ),
          TableRow(
            children: [
              Text('EXTRA # HITS'),
              Text(advancedInfo['number_of_hits']['extra']),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget _buildStatus(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Container(
          height: deviceHeight / 2.2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _showImage == 0 ? Expanded(child: _ascensions()) : Empty(),
              _showImage == 1 ? Expanded(child: _sprites()) : Empty(),
              Row(
                children: [
                  RaisedButton(
                    onPressed: _toggleImagesCreator(0),
                    child: Text('Ascensions'),
                  ),
                  RaisedButton(
                    onPressed: _toggleImagesCreator(1),
                    child: Text('Sprites'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _class(),
                  _deck(),
                ],
              ),
              _status(),
              _activeSKills == null ? Empty() : _activeSkills(),
              _classSkills == null ? Empty() : _buildClassSkills(),
              _traits(),
              _advanced(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBiography() {
    final Map biography = _details['biography'];
    final rowBuilder = (key) => TableRow(
      decoration: BoxDecoration(),
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            key.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Text(
            biography[key],
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );

    final List bondKeys = biography.keys
      .where((key) => key.toString().contains('bond'))
      .toList();
    bondKeys.sort((a, b) => a.compareTo(b));

    final children = [rowBuilder('default')];
    children.addAll(bondKeys.map(rowBuilder));
    biography['extra'] != null
      ? children.add(rowBuilder('extra'))
      : null;
    return ListView(
      padding: EdgeInsets.only(
        right: 30.0,
        left: 20.0,
      ),
      children: [
        Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey,),
          ),
          columnWidths: {
            0: FractionColumnWidth(0.2),
            1: FractionColumnWidth(0.9),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: children,
        ),
      ]
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _toggleBottomNavigationBar,
      currentIndex: _navigationBottomIndex,
      items: [
        BottomNavigationBarItem(
          title: Text('Status'),
          icon: Icon(Icons.accessibility),
        ),
        BottomNavigationBarItem(
          title: Text('Biography'),
          icon: Icon(Icons.comment),
        ),
      ],
    );
  }

  _toggleBottomNavigationBar(int index) {
    setState(() {
      _navigationBottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Material(
        child: _navigationBottomIndex == 0
          ? _buildStatus(context)
          : _buildBiography(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
