import 'package:flutter/material.dart';
import 'dart:async';

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

final quickIcon = Image.asset('assets/quick.png');
final busterIcon = Image.asset('assets/buster.png');
final artsIcon = Image.asset('assets/arts.png');

final errorImage = Image.asset('assets/error.jpg');

final unidentifiedItem = Container(
  width: 40.0,
  height: 40.0,
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.black,
      width: 1.0,
    ),
  ),
  child: Center(
    child: Text('?'),
  ),
);

class _MainLoadingState extends State<MainLoading> {
  int _index = 0;
  final _frames = [
    Image.asset('assets/1_transparent.png'),
    Image.asset('assets/2_transparent.png'),
    Image.asset('assets/3_transparent.png'),
    Image.asset('assets/4_transparent.png'),
    Image.asset('assets/5_transparent.png'),
    Image.asset('assets/6_transparent.png'),
    Image.asset('assets/7_transparent.png'),
    Image.asset('assets/8_transparent.png'),
  ];

  Timer _timer;

  @override
  void initState() {
    super.initState();
    this._timer = Timer.periodic(
      Duration(milliseconds: 600),
      (timer) {
        setState(() {
          _index = (_index + 1) % 8;
        });
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
        height: 50.0,
        child: _frames[_index],
      ),
    );
  }

}

class MainLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainLoadingState();
  }
}
