import 'package:journal/presenters/base.dart';
import 'package:rxdart/rxdart.dart';

class BaseManager {
  void dispose() {
    _scaffoldSubject.close();
  }

  BehaviorSubject<ScaffoldPresentation> _scaffoldSubject = BehaviorSubject();

  Stream<ScaffoldPresentation> get scaffoldStream =>
      _scaffoldSubject.stream.distinct();

  // Adds presentation to scaffoldStream, then null to clear later states
  void presentToScaffold(ScaffoldPresentation bar) {
    _scaffoldSubject.add(bar);
  }
}
