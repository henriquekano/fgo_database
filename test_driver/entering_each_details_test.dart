import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'servants_list.dart';

void main() {
  group('When viewing the details of a servant', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    final servantsInABatch = SERVANT_OPTIONS.length ~/ 40;
    final batches = 40;
    final timeoutSeconds = 100;

    for(var i = 35; i < batches; i++) {

      test('the pages shouldn\'t crash the app (${i * servantsInABatch}/${SERVANT_OPTIONS.length})', () async {
          for (var j = 0; j < servantsInABatch; j++) {
            final name = SERVANT_OPTIONS[i * servantsInABatch + j];
            print(name);
            final servantName = find.text(name);
            final backButton = find.byTooltip('Back');
            final biography = find.text('Biography');
            final scrollable = find.byValueKey('servants_list');
            final sprites = find.text('Sprites');

            await driver.waitFor(scrollable, timeout: Duration(seconds: timeoutSeconds));
            await driver.scrollUntilVisible(
              scrollable,
              servantName,
              dyScroll: -300.0,
              timeout: Duration(seconds: timeoutSeconds),
            );
            await driver.tap(servantName, timeout: Duration(seconds: timeoutSeconds));
            await driver.tap(sprites, timeout: Duration(seconds: timeoutSeconds));
            await driver.tap(biography, timeout: Duration(seconds: timeoutSeconds));
            await driver.tap(backButton, timeout: Duration(seconds: timeoutSeconds));
          }
      });
    }
  });
}
