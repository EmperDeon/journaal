import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:journal/managers.dart';
import 'package:journal/models.dart';
import 'package:journal/screens/app.dart';
import 'package:journal/services.dart';
import 'package:journal/util/build_env.dart';
import 'package:journal/util/crypto.dart';
import 'package:journal/util/storage.dart';

void main() async {
  await initStorage();

  initServices();
  initModels();
  initManagers();

  runApp(App());
}

Future initStorage() async {
  await DotEnv().load('.env');

  sl.registerSingleton<BuildEnv>(DebugBuildEnv());
  // sl.registerSingleton<BuildEnv>(ReleaseBuildEnv());

  Storage storage = Storage();
  storage.loadFromStorage();

  Crypto crypto = Crypto();

  sl.registerSingleton<Storage>(storage);
  sl.registerSingleton<Crypto>(crypto);
}
