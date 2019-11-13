import 'package:journal/managers/entries.dart';
import 'package:journal/managers/entry.dart';
import 'package:journal/managers/settings.dart';
import 'package:journal/managers/unlock.dart';
import 'package:journal/services.dart';

void initManagers() {
  sl.registerSingleton<SettingsManager>(SettingsManagerImpl());
  sl.registerSingleton<UnlockManager>(UnlockManagerImpl());
  sl.registerSingleton<EntriesManager>(EntriesManagerImpl());
  sl.registerSingleton<EntryManager>(EntryManagerImpl());
}
