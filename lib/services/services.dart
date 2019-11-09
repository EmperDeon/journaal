import 'package:get_it/get_it.dart';
import 'package:journal/services/navigation_service.dart';

void initServices() {
  GetIt.I.registerSingleton(NavigationService());
}
