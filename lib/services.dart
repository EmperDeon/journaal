import 'package:get_it/get_it.dart';
import 'package:journal/services/navigation_service.dart';

GetIt sl = GetIt.I;

void initServices() {
  sl.registerSingleton<NavigationService>(NavigationService());
}
