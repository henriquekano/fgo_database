import 'package:fgo_database/fgo_webscrape.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('When parsing a grandorder.gamepress.gg servant info,', () {
    GamepressServantParser parser;
    setUpAll(() {
      final currentDirectory = Directory.current.path;
      final mashExample = new File(currentDirectory + '/test/mash.html');
      final html = mashExample.readAsStringSync();
      parser = new GamepressServantParser(html);
    });

    test('it parses the name', () {
      expect(parser.parseName(), "Mash Kyrielight");
    });

    test('it parses the ascension images', () {
      expect(parser.parseAscentions(), [
        'https://grandorder.gamepress.gg/sites/grandorder/files/styles/servant_image/public/2017-07/Shielder1.png?itok=5IXaEnku',
        'https://grandorder.gamepress.gg/sites/grandorder/files/styles/servant_image/public/2017-07/Shielder2.png?itok=29tTWkn-',
        'https://grandorder.gamepress.gg/sites/grandorder/files/styles/servant_image/public/2017-07/Shielder3.png?itok=QTQQJ0rB',
        'https://grandorder.gamepress.gg/sites/grandorder/files/styles/servant_image/public/2017-07/Shielder4.png?itok=GdpqyzuB'
      ]);
    });

    test('it parses the deck information', () {
      expect(parser.parseDeckInformation(), {
        'arts': 2,
        'buster': 2,
        'quick': 1,
      });
    });

    test('it parses the other information', () {
      expect(parser.parseOtherInfo(), {
        "stars": {
            "absorption": '99',
            "generation": "9.9%"
        },
        "noble_phantasm": {
            "charge": "0.84%",
            "attacked": "3%"
        },
        "number_of_hits": {
            "arts": '2',
            "buster": '1',
            "quick": '2',
            "extra": '3'
        },
        "traits": [
            "Humanoid", "Servant", "Riding", "Weak to Enuma Elish", "Heaven or Earth"
        ],
        "instant_death": "24.50%"
      });
    });

    test('it parses the skill enhancements material list', () {
      expect(parser.parseSkillEnhancementMaterials(), [
        {
          "cost": '50,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Heros_proof_1.png?itok=cSPil8qI",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '100,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Dragon_fang_0.png?itok=kIlRtjAL",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '300,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Yggdrasil_seed_0.png?itok=yxoFZX6t",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '400,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Octuplet_twin_crystals_0.png?itok=RyUGLzGe",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '1,000,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Voids_refuse_1.png?itok=kKrJQ6oI",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '1,250,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Infinity_gear_1_0.png?itok=cemIKZyL",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '2,500,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Phoenix_plume_0.png?itok=8oBiQ6_n",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '3,000,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-07/Dragons_reverse_scale_0.png?itok=R-Unoox0",
              "quantity": 'x5'
            }
          ]
        },
        {
          "cost": '5,000,000',
          "materials": [
            {
              "image_url":
                  "https://grandorder.gamepress.gg/sites/grandorder/files/styles/height50px/public/2017-10/Crystallized_lore_0.png?itok=s866dPqy",
              "quantity": 'x1'
            }
          ]
        }
      ]);
    });

    test('it parses the noble phantasms', () {
      expect(parser.parseNoblePhantasms(), [
        {
          "name": "Lord Chaldeas",
          "type": "arts",
          "description": "Reduces damage taken by all party members (3 turns).",
          "rank": "D",
          "classification": "Anti-Personnel",
          "hit_count": '0',
          "effects": {
            "damage taken -": ['100', '550', '775', '888', '1000'],
            "defense +": ["30%", "35%", "40%", "45%", "50%"]
          }
        },
        {
          "name": "Lord Camelot",
          "type": "arts",
          "description":
              "Reduces damage taken by all party members (3 turns). Increase party's attack damage by 30% except self for 3 turns.",
          "rank": "B+++",
          "classification": "Anti-Evil",
          "hit_count": '0',
          "effects": {
            "damage taken -": ['100', '550', '775', '888', '1000'],
            "defense +": ["30%", "35%", "40%", "45%", "50%"]
          }
        }
      ]);
    });

    test('it parses the status', () {
      expect(parser.parseStatus(), {
        'rarity': 3,
        'id': '1',
        'cost': '0',
        'class': 'Shielder',
        'attribute': 'Earth',
        'base_atk': '1,261',
        'base_hp': '1,854',
        'max_atk': '6,791',
        'max_hp': '10,302',
        'grail_atk': '10,575',
        'grail_hp': '15,619'
      });
    });

    test('it parses the class\' skills', () {
      expect(parser.parseClassSkills(), [
        {
          "name": "Magic Resistance A",
          "description": "Increases debuff resistance by 20%.",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Anti_magic.png?itok=HXk6UqjW"
        },
        {
          "name": "Riding C",
          "description": "Increases Quick card effectiveness by 6%.",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Riding.png?itok=DBQT8lxl"
        }
      ]);
    });

    test('it parses the active skills', () {
      expect(parser.parseActiveSkills(), [
        {
          "name": "Transient Wall of Snowflakes",
          "description": "Increases party's defense for 3 turns.",
          "unlock_condition": "Available from the start",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Shieldup.png?itok=JbwBtLTN",
          "effects": {
            "defense +": [
              "10%",
              "10.5%",
              "11%",
              "11.5%",
              "12%",
              "12.5%",
              "13%",
              "13.5%",
              "14%",
              "15%"
            ]
          },
          "cooldown": ['7', '7', '7', '7', '7', '6', '6', '6', '6', '5']
        },
        {
          "name": "Honorable Wall of Snowflakes",
          "description":
              "Increases party's defense for 3 turns. Reduces party's damage taken by 2000 for 1 attack.",
          "unlock_condition":
              "Clear King of Kings Ozymandias stage 1/3 in Camelot",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Shieldup.png?itok=JbwBtLTN",
          "effects": {
            "defense +": [
              "15%",
              "15.5%",
              "16%",
              "16.5%",
              "17%",
              "17.5%",
              "18%",
              "18.5%",
              "19%",
              "20%"
            ]
          },
          "cooldown": ['7', '7', '7', '7', '7', '6', '6', '6', '6', '5']
        },
        {
          "name": "Obscurant Wall of Chalk",
          "description":
              "Grants one ally's Invincibility for 1 turn. Charges their NP gauge.",
          "unlock_condition": "Available from the start",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Invishield.png?itok=5C_dhu55",
          "effects": {
            "np +": [
              "10%",
              "11%",
              "12%",
              "13%",
              "14%",
              "15%",
              "16%",
              "17%",
              "18%",
              "20%"
            ]
          },
          "cooldown": ['9', '9', '9', '9', '9', '8', '8', '8', '8', '7']
        },
        {
          "name": "Shield of Rousing Resolution",
          "description":
              "Draws attention of all enemies to self for 1 turn. Increases own NP generation rate for 1 turn.",
          "unlock_condition": "Unlocks after 2nd Ascension",
          "image":
              "https://grandorder.gamepress.gg/sites/grandorder/files/styles/45x45/public/2017-07/Taunt.png?itok=M66IxN-b",
          "effects": {
            "np rate +": [
              "200%",
              "220%",
              "240%",
              "260%",
              "280%",
              "300%",
              "320%",
              "340%",
              "360%",
              "400%"
            ]
          },
          "cooldown": ['8', '8', '8', '8', '8', '7', '7', '7', '7', '6']
        }
      ]);
    });
  });
  group('When parsing a wiki servant info,', () {
    WikiParser parser;
    setUpAll(() {
      final currentDirectory = Directory.current.path;
      final mashExample = new File(currentDirectory + '/test/wiki_mash.html');
      final html = mashExample.readAsStringSync();
      parser = new WikiParser(html);
    });

    test('it parses the ascention images', () {
      final images = parser.parseAscentions();
      expect(images, [
        'https://vignette.wikia.nocookie.net/fategrandorder/images/b/b0/Shielder1.png/revision/latest?cb=20170206150321',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/c/cf/Shielder2.png/revision/latest?cb=20180404185036',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/3/32/Shielder3.png/revision/latest?cb=20170206150347',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/c/c3/Shielder4.png/revision/latest?cb=20170206150355',
      ]);
    });

    test('it parses the sprite images', () {
      final images = parser.parseSprites();
      expect(images, [
        'https://vignette.wikia.nocookie.net/fategrandorder/images/d/d8/Mashu_new_1.png/revision/latest?cb=20180405040226',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/a/a9/Mashu_new_2.png/revision/latest?cb=20180405040226',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/5/5b/Mashu_new_3.png/revision/latest?cb=20180405040227',
      ]);
    });

    test('it parses the biography', () {
      final biography = parser.parseBiography();
      final expected = {
        'default': "The form of Mashu Kyrielite, a Chaldea clerk, who underwent a possession union with a Servant.\nThis is called a Demi-Servant.",
        'bond 1': 'Height/Weight: 158cm ・ 46kg\nSource: Fate/Grand Order\nRegion: Chaldea\nAlignment: Lawful ・ Good\nGender: Female',
        'bond 2': 'Virtual Noble Phantasm Pseudo-Deployment/Foundation of Anthropic Principle\nRank: D\nType: Anti-Unit\nLord Chaldeas.\nThe Noble Phantasm deployed by Mash in accordance to her instincts, without understanding the True Name of the Heroic Spirit possessing her.\nAs for why it is crowned with the name of Chaldea, one would think that is because the wish that lies on Mash\'s basis is "to see the future of mankind".\n< Text changes after clearing Replica(4/5) >\nFortress of the Distant Utopia\nRank: B+++\nType: Anti-Evil\nLord Camelot.\nThe Noble Phantasm that Heroic Spirit Galahad possesses.\nThe ultimate protection that employed the Round Table - where the Knights of the Round Table sat at the center of the Castle of White Walls, Camelot - in the form of a shield.\nIts strength is proportionate to the willpower of the user, and it has been said that, so long the heart doesn\'t break, those castle walls too shall never crumble.',
        'bond 3': 'Self-Field Defense: C\nA power displayed when protecting allies or an allied camp.\nExhibits damage reduction surpassing the defensive limit value, but she herself is not included as a target.\nAlso, the higher the Rank more the protective range spreads.',
        'bond 4': 'Possession Inheritance: ?\nSucceed Phantasm. An unique Skill that Demi-Servants possess. One of the Skills that the possessing Heroic Spirit owns is inherited and sublimated in a self-taught manner.\nIn Mash\'s case, it is "Prana Defense".\nA Skill of the same type as "Prana Burst", magical power is translated directly into defensive power.\nFor a Heroic Spirit possessing a huge magical power, it would probably become a sacred wall that protects a whole country.',
        'bond 5': 'Mash has obtained the True Name of the Heroic Spirit possessing her.\nThe name of that knight is Galahad.\nOne of the Knights of the Round Table from Arthurian Legends.\nThe saint who was the only one to obtain the Holy Grail, just to return it to heavens.\nChaldea had success in summoning Heroic Spirits with its own original method, but what lies at its foundation is the "place where heroes assemble" - the shield held by Mash, which made use of the Round Table and became the catalyst for summoning Galahad.',
        'extra': 'After passing over seven singularities and overcoming many battles, she grew up as a single fully-fledged human, a Servant that is not merely a borrowed article.\nThe virtual Noble Phantasm she used before learning the True Name - Foundation of Anthropic Principle (Lord Chaldeas).\nThat was the wish found at her roots - “to see the future of mankind” - given shape.\n...the battle surrounding the incineration of the anthropic principle will soon come to an end.\nWhat sort of conclusion will her journey reach?\nThe beast of the planet continues to silently watch over that snowflake-like scenery.',
      };
      expect(biography, expected);
    });

    test('it parses the icons', () {
      final icons = parser.parseIcons();
      final expected = [
        'https://vignette.wikia.nocookie.net/fategrandorder/images/a/ab/Mashuicon.png/revision/latest?cb=20180203135138',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/8/8f/MashuStage2Icon.png/revision/latest?cb=20180523153745',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/3/30/MashuIconSR.png/revision/latest?cb=20180203135159',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/0/0d/MashuStage2GoldIcon.png/revision/latest?cb=20180523153823',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/1/18/MashuStage3GoldIcon.png/revision/latest?cb=20180523153831',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/b/b6/MashuKyrielightFinalIcon.png/revision/latest?cb=20180211123053',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/b/b3/MashuCostume01.png/revision/latest?cb=20180215131819',
        'https://vignette.wikia.nocookie.net/fategrandorder/images/8/87/MashOrtenaus.png/revision/latest?cb=20180530123037',
      ];
      expect(icons, expected);
    });
  });
}
