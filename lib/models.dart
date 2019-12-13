import 'package:journal/models/journals.dart';
import 'package:journal/models/notes.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services.dart';

void initModels() {
  sl.registerSingleton<NotesModel>(NotesModelImpl());
  sl.registerSingleton<JournalsModel>(JournalsModelImpl());
  sl.registerSingleton<SettingsModel>(SettingsModelImpl());
}
