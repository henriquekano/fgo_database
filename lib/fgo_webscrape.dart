import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document, Element;
import 'package:dio/dio.dart' show Dio;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:async';

String _removeMultipleBlanks(String string) {
  return string
    .replaceAll(
      new RegExp('(\\n| ){2,}', multiLine: true),
      ' '
    ).trim();
}

class GamepressServantParser {
  static const GAMEPRESS_HOSTNAME = 'https://grandorder.gamepress.gg';

  Document _htmlDocument;

  GamepressServantParser(String html)
    : this._htmlDocument = parse(html);

  String parseName() {
    final nameNode = _htmlDocument.querySelector('[property="og:title"]');
    return nameNode.attributes['content'];
  }

  List<String> parseAscentions() {
    final ascentionImages = _htmlDocument.querySelectorAll('img.image-style-servant-image');
    return ascentionImages.map((imageNode) {
      return GAMEPRESS_HOSTNAME + imageNode.attributes['src'];
    }).toList();
  }

  Map<String, dynamic> parseStatus() {
    final staticStatus = _htmlDocument.querySelectorAll('#servant-sub-table tbody tr');
    final rarity = staticStatus[0].querySelectorAll('.fa-star').length;
    final id = staticStatus[1].querySelector('td').text;
    final cost = staticStatus[2].querySelector('td').text;
    final clazz = staticStatus[3].querySelector('td').text;
    final attribute = staticStatus[4].querySelector('td').text;

    final status = _htmlDocument.querySelectorAll('#atkhp-table td');
    final baseAtk = status[0].text;
    final baseHp = status[1].text;
    final maxAtk = status[2].text;
    final maxHp = status[3].text;
    final grailAtk = status[4].text;
    final grailHp = status[5].text;

    return {
      'rarity': rarity,
      'id': id,
      'cost': cost,
      'class': clazz,
      'attribute': attribute,
      'base_atk': baseAtk,
      'base_hp': baseHp,
      'max_atk': maxAtk,
      'max_hp': maxHp,
      'grail_atk': grailAtk,
      'grail_hp': grailHp
    };
  }

  Map<String, dynamic> _parseActiveSkillLevelTable(Element document) {
    final levelTable = document.querySelectorAll('.stats-skill-table tr');

    final processTableRow =
      (Map<String, dynamic> accumulator, dynamic nextValue) {
        final effectName = _removeMultipleBlanks(
          nextValue.querySelector('th').text
        );
        final effectByLevel = nextValue.querySelectorAll('td')
          .map((item) {
            return _removeMultipleBlanks(item.text);
          })
          .toList();
        accumulator[effectName.toLowerCase()] = effectByLevel;

        return accumulator;
      };

    return levelTable
      .skip(1) //levels row
      .take(levelTable.length - 2)
      .fold({}, processTableRow);
  }

  List<String> _parseActiveSkillCooldown(Element document) {
    final cooldownRow = document.querySelectorAll('.stats-skill-table tr').last;

    return cooldownRow
      .querySelectorAll('td')
      .map((item) {
        return item.text;
      })
      .toList();
  }

  Map<String, dynamic> _parseActiveSkill(Element document) {
    final unlockCondition = _removeMultipleBlanks(
      document.querySelector('.views-field-field-skill-unlock').text.trim()
    );
    final name = _removeMultipleBlanks(
      document.querySelector('.field--name-title').text.trim()
    );
    final description = _removeMultipleBlanks(
      document.querySelector('a + p').text
    );
    final image = document.querySelector('.field--name-field-active-skill-image img').attributes['src'];

    final effects = _parseActiveSkillLevelTable(document);

    final coolDown = _parseActiveSkillCooldown(document);

    return {
      'unlock_condition': unlockCondition,
      'name': name,
      'description': description,
      'image': GAMEPRESS_HOSTNAME + image,
      'effects': effects,
      'cooldown': coolDown
    };
  }

  List<dynamic> parseActiveSkills() {
    try {
      final activeSkills =_htmlDocument.querySelectorAll('.view-servant-skills-node .views-row')
        .map((item) {
          return _parseActiveSkill(item);
        })
        .toList();

      return activeSkills.toList();
    } on NoSuchMethodError {
      return [];
    }
  }

  Map<String, String> _parseClassSkill(Element document) {
    final image = document.querySelector('img').attributes['src'];
    final name = document.querySelector('a').text;
    final description = document.querySelector('p').text;

    return {
      'name': _removeMultipleBlanks(name),
      'description': _removeMultipleBlanks(description),
      'image': GAMEPRESS_HOSTNAME + image
    };
  }

  List<Map<String, String>> parseClassSkills() {
    try {
      final classSkills = _htmlDocument.querySelectorAll('.view-class-skills-node .views-row');

      return classSkills
        .map((skill) {
          return _parseClassSkill(skill);
        })
        .toList();
    } on NoSuchMethodError {
      return [];
    }
  }

  Map<String, List<String>> _parseNoblePhantasmEffects(Element document) {
    try {
      final bottomTable = document.querySelector('#np-bottom-table');
      final effects = bottomTable.querySelectorAll('tr')
        .where((row) { //remove the charge and level rows - useless
          final rowEffectName = _removeMultipleBlanks(
            row.querySelector('th').text
          ).toLowerCase();
          return !['charge', 'level'].contains(rowEffectName);
        });

      final effectsToList = (Element document) {
        return document.querySelectorAll('td')
            .map((item) {
              return _removeMultipleBlanks(item.text);
            })
            .toList();
      };

      return effects
        .fold({}, (accumulator, nextValue) {
          final effectName = _removeMultipleBlanks(
            nextValue.querySelector('th').text
          );
          final effectList = effectsToList(nextValue);
          accumulator[effectName.toLowerCase()] = effectList;

          return accumulator;
        });
    } on NoSuchMethodError {
      return {};
    }
  }

  Map<String, dynamic> _parseNoblePhantasm(Element document) {
    try {
      final name = document.querySelector('.np-main-title').text;

      final topTable = document.querySelector('#np-top-table');
      final topTableValues = topTable.querySelectorAll('tr').last
        .querySelectorAll('td');
      final rank = topTableValues.first.text;
      final classification = topTableValues[1].text;
      final hitCount = topTableValues[2].text.isEmpty ? '0' : topTableValues[2].text;

      final midTableValues = document.querySelectorAll('#np-mid-table p');
      final description = midTableValues[0].text;

      final effects = _parseNoblePhantasmEffects(document);

      final artType = document.querySelector('img[src*="Command_Card_Arts"]');
      final busterType = document.querySelector('img[src*="Command_Card_Buster"]');
      final quickType = document.querySelector('img[src*="Command_Card_Quick"]');
      var type;
      if (artType != null) {
        type = 'arts';
      } else if (busterType != null) {
        type = 'buster';
      } else {
        type = 'quick';
      }

      return {
        'type': type,
        'name': name,
        'description': _removeMultipleBlanks(description),
        'rank': rank,
        'classification': classification,
        'hit_count': hitCount,
        'effects': effects,
      };
    } on RangeError {
      return {};
    }
  }

  List<Map<String, dynamic>> parseNoblePhantasms() {
    return _htmlDocument.querySelectorAll('.np-main-title')
      .map((item) {
        return _parseNoblePhantasm(item.parent);
      })
      .toList();
  }

  Map<String, dynamic> _parseSkillRequirements(Element document) {
    final cost = document.querySelector('.Skill-cost').text;

    final materials =  document.querySelectorAll('.Skill-materials .paragraph--type--required-materials');
    final processRequirement = (materialRequirement) {
      final quantity = materialRequirement.querySelector('.field--name-field-number-of-materials').text;
      final image = materialRequirement.querySelector('img').attributes['src'];
      return {
        'image_url': GAMEPRESS_HOSTNAME + image,
        'quantity': quantity
      };
    };
    final materialRequirements = materials
      .map(processRequirement)
      .toList();

    return {
      'cost': cost,
      'materials': materialRequirements
    };
  }

  List<Map<String, dynamic>> parseSkillEnhancementMaterials() {
    try {
      final skillEnhancementTable = _htmlDocument.querySelector('#Skill-materials-table');
      return skillEnhancementTable
        .querySelectorAll('tr')
        .skip(1) //header
        .map(_parseSkillRequirements)
        .toList();
    } on NoSuchMethodError {
      return [];
    }
  }

  Map<String, dynamic> parseOtherInfo() {
    final otherInfo = _htmlDocument.querySelectorAll('#other-info-section td');

    final starAbsorption = otherInfo[0].text;
    final starGeneration = otherInfo[1].text;
    final npChargePerHit = otherInfo[2].text;
    final npChargeWhenAttacked = otherInfo[3].text;
    final numberOfHitsArts = otherInfo[4].text;
    final numberOfHitsBuster = otherInfo[5].text;
    final numberOfHitsQuick = otherInfo[6].text;
    final numberOfHitsExtra = otherInfo[7].text;
    final deathChance = otherInfo[18].text;

    final traits = _htmlDocument.querySelectorAll('#trait-table a')
      .map((item) {
        return item.text;
      })
      .toList();

    return {
      'stars': {
        'absorption': starAbsorption,
        'generation': starGeneration
      },
      'noble_phantasm': {
        'charge': npChargePerHit,
        'attacked': npChargeWhenAttacked
      },
      'number_of_hits': {
        'arts': numberOfHitsArts,
        'buster': numberOfHitsBuster,
        'quick': numberOfHitsQuick,
        'extra': numberOfHitsExtra
      },
      'traits': traits,
      'instant_death': deathChance
    };
  }

  Map<String, dynamic> parseDeckInformation() {
    try {
      final deck = _htmlDocument.querySelector('.field--name-field-command-cards');
      final arts = deck.querySelectorAll('img[src*="Command_Card_Arts"]').length;
      final buster = deck.querySelectorAll('img[src*="Command_Card_Buster"]').length;
      final quick = deck.querySelectorAll('img[src*="Command_Card_Quick"]').length;

      return {
        'arts': arts,
        'buster': buster,
        'quick': quick,
      };
    } on NoSuchMethodError {
      return {};
    }
  }

  Map<String, dynamic> parseServantInformation() {
    final name = parseName();
    final ascentions = parseAscentions();
    final status = parseStatus();
    final activeSkills = parseActiveSkills();
    final classSkills = parseClassSkills();
    final noblePhantasms = parseNoblePhantasms();
    final skillEnhancementMaterials = parseSkillEnhancementMaterials();
    final other = parseOtherInfo();
    final deck = parseDeckInformation();
    return {
      'name': name,
      'status': status,
      'ascencions': ascentions,
      'active_skills': activeSkills,
      'class_skills': classSkills,
      'noble_phantasms': noblePhantasms,
      'skill_enhancement_materials': skillEnhancementMaterials,
      'advanced_info': other,
      'deck': deck,
    };
  }
}

class WikiParser {
  Document _htmlDocument;
  final GAMEPRESS_HOSTNAME = 'https://grandorder.gamepress.gg';

  WikiParser(String html)
    : this._htmlDocument = parse(html);

  List<String> parseAscentions() {
    final images =_htmlDocument.querySelectorAll('.ServantInfoMain a[title*="Stage"]');
    return images.map((url) {
      return url.attributes['href'].toString();
    })
    .toList();
  }

  List<String> parseSprites() {
    final sprites = _htmlDocument.querySelectorAll('.ServantInfoMain a[title^="Sprite"]');
    return sprites.map((url) {
      return url.attributes['href'].toString();
    })
    .toList();
  }

  String parseName() {
    final name = _htmlDocument.querySelector('.ServantInfoName > b').text;
    return _removeMultipleBlanks(name);
  }

  Map<String, String> parseBiography() {
    try {
      final biographyTable = _htmlDocument.querySelector('#Biography').parent.nextElementSibling;
      final biographyRows = biographyTable.querySelectorAll('tr').skip(1);
      final biographyDict = biographyRows.fold<Map<String, String>>({}, (acc, row) {
        final name = row.querySelector('th').text.toLowerCase();
        final value = row.querySelectorAll('td').last.innerHtml;
        final sanitizedValue = value
          .replaceAll('&nbsp;', ' ')
          .replaceAll(RegExp('^(\b|\n| )+'), '')
          .replaceAll('<br>', '\n')
          .replaceAll('<p>', '\n')
          .replaceAll('</p>', '')
          .replaceAll('<b>', '')
          .replaceAll('</b>', '')
          .replaceAll(RegExp('\<[^\>]*\>'), '')
          .replaceAll(RegExp('(\\n){2,}', multiLine: true), '\n')
          .replaceAll(RegExp('(\\n| )+\$'), '');

        acc[_removeMultipleBlanks(name)] = HtmlUnescape().convert(sanitizedValue);
        return acc;
      });
      return biographyDict;
    } on Exception {
      print('Wat');
      return {};
    }
  }

  Map<String, String> parseStatus() {
    final status = _htmlDocument.querySelectorAll('.ServantInfoStatsWrapper .closetable')[1];
    final id = status.querySelector('tbody > tr > td').innerHtml
      .replaceAll(RegExp('<.+>'), '');
    return {
      'id': _removeMultipleBlanks(id),
    };
  }

  List<String> parseIcons() {
    final icons = _htmlDocument.querySelectorAll('div[title="Icons"] img[title]');
    if (icons.length <= 0) {
      print('wat');
    }
    return icons.map((icon) => icon.attributes['data-src']).toList();
  }
}

Iterable<String> _wikiaServantLinks(Document html) =>
  html.querySelectorAll('table.wikitable > tbody > tr')
    .where((item) {
      final firstTd = item.querySelector('a');
      return firstTd != null;
    })
    .map((item) {
      final firstTd = item.querySelector('a');
      return 'http://fategrandorder.wikia.com' + firstTd.attributes['href'];
    });

Future<Map> _wikiaDownloadAndParseServantStatus(String link) async {
  final dio = new Dio();
  var response;
  try {
    response = await dio.get(link);
  } on Exception {
    response = await Future.delayed(
      Duration(seconds: 10),
      () => dio.get(link),
    );
  }

  final parser = WikiParser(response.data);
  final sprites = parser.parseSprites();
  final name = parser.parseName();
  final status = parser.parseStatus();
  final icons = parser.parseIcons();
  final biography = parser.parseBiography();

  print('Saving ${status["id"]} - $name');
  return Map<String, dynamic>.from({
    'sprites': sprites,
    'name': name,
    'id': status['id'],
    'icons': icons,
    'biography': biography,
  });
}

_updateFirebaseDocuments(List<DocumentSnapshot> snapshots, Map<String, dynamic> status) {
  final snapshot = snapshots.firstWhere((sna) =>
    sna.documentID == status['id']
  );
  final currentData = snapshot.data;
  if (true) {
    currentData['sprites'] = status['sprites'];
    currentData['biography'] = status['biography'];

    Firestore.instance.collection('servants')
      .document(status['id'])
      .updateData(currentData);
  }
}

void saveServantsToFirebase() async {
  final dio = new Dio();
  final response = await dio.get('http://fategrandorder.wikia.com/wiki/Servant_List_by_ID');
  final html = parse(response.data);
  final servantLinks = _wikiaServantLinks(html);
  final snapshots = await Firestore.instance.collection('servants')
    .getDocuments()
    .then((QuerySnapshot doc) {
      return doc.documents;
    });

  ['http://fategrandorder.wikia.com/wiki/Atalanta_(Alter)'].forEach((url) async {
    final status = await _wikiaDownloadAndParseServantStatus(url);
    _updateFirebaseDocuments(snapshots, status);
  });
}
