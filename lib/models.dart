import 'package:journal/models/entries_model.dart';
import 'package:journal/models/settings_model.dart';
import 'package:journal/services.dart';

void initModels() {
  sl.registerSingleton<EntriesModel>(EntriesModelImpl());
  sl.registerSingleton<SettingsModel>(SettingsModelImpl());
}
