import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../../services/notifi_service.dart';
import 'app.dart';
import 'bootstrapper.dart';
import 'flavor.dart';

Future<void> launchApp({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // ignore: always_specify_types
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initNotifications();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(
    App(bootstrapper: Bootstrapper.fromFlavor(flavor)),
  );
}
