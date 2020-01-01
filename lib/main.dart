import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:journal/managers/app.dart';
import 'package:journal/models.dart';
import 'package:journal/screens/app.dart';
import 'package:journal/services.dart';
import 'package:journal/util/build_env.dart';
import 'package:journal/util/crypto.dart';
import 'package:journal/util/storage.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await initStorage();

  initServices();
  initModels();

  postInit();

  runApp(App());
}

Future initStorage() async {
  await DotEnv().load('.env');
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  sl.registerSingleton<BuildEnv>(DebugBuildEnv());
  // sl.registerSingleton<BuildEnv>(ReleaseBuildEnv());

  Storage storage = Storage();
  storage.loadFromStorage();

  Crypto crypto = Crypto();

  sl.registerSingleton<Storage>(storage);
  sl.registerSingleton<Crypto>(crypto);
}

void postInit() {
  sl.registerSingleton<AppManager>(AppManagerImpl());
}
