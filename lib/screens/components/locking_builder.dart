import 'package:flutter/widgets.dart';
import 'package:journal/managers/app.dart';
import 'package:journal/services.dart';

class LockingBuilder extends StreamBuilder {
  LockingBuilder({
    Function(BuildContext) enabledBuilder = buildEmpty,
    Function(BuildContext) disabledBuilder = buildEmpty,
    Key key,
  }) : super(
          stream: sl<AppManager>().lockingStream,
          initialData: {},
          builder: (_, snap) => (snap.data['lockingEnabled'] ?? true)
              ? enabledBuilder(_)
              : disabledBuilder(_),
        );

  static Widget buildEmpty(BuildContext c) => SizedBox.shrink();
}
