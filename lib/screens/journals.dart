import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/journals.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/base.dart';

class JournalsScreen extends BaseScreen<JournalsManager> {
  static const String routeName = '/journals';

  JournalsScreen({Key key}) : super(titleTr: 'screens.journals', key: key);

  @override
  Widget buildContent(BuildContext c, JournalsManager manager) {
    return Center(
      child: StreamBuilder(
        stream: manager.itemKeysStream,
        initialData: [],
        builder: (_, snap) {
          return ListView.separated(
            itemCount: snap.data.length,
            itemBuilder: (_c, index) => buildTile(c, manager, snap.data[index]),
            separatorBuilder: (_c, _i) => Divider(),
          );
        },
      ),
    );
  }

  Widget buildTile(BuildContext c, JournalsManager manager, String id) {
    Journal journal = manager[id];

    if (journal != null)
      return ListTile(
        key: ValueKey(id),
        title: Text(l(c, 'date', journal.date)),
        onTap: () => manager.openJournal(id),
      );
    else
      return null;
  }

  // Screen Drawer
  @override
  BasicDrawer buildDrawer() => BasicDrawer(currentRoute: routeName);

  @override
  Widget buildFloatingButton(BuildContext c, JournalsManager manager) =>
      FloatingActionButton(
        onPressed: manager.create,
        tooltip: t(c, 'actions.add'),
        child: new Icon(Icons.add),
      );

  @override
  JournalsManager createManager() => JournalsManagerImpl();
}
