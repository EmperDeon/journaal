import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/notes.dart';
import 'package:journal/models/note.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/base.dart';

class NotesScreen extends BaseScreen<NotesManager> {
  static const String routeName = '/';

  NotesScreen({Key key}) : super(titleTr: 'screens.notes', key: key);

  @override
  Widget buildContent(BuildContext c, NotesManager manager) {
    return Center(
      child: StreamBuilder(
        stream: manager.itemKeysStream,
        initialData: [],
        builder: (_, snap) {
          return ListView.separated(
            itemCount: snap.data.length,
            itemBuilder: (_c, index) => buildTile(manager, snap.data[index]),
            separatorBuilder: (_c, _i) => Divider(),
          );
        },
      ),
    );
  }

  Widget buildTile(NotesManager manager, String id) {
    Note note = manager[id];

    if (note != null)
      return ListTile(
        title: Text(note.title),
        onTap: () => manager.openNote(id),
      );
    else
      return null;
  }

  // Screen Drawer
  @override
  BasicDrawer buildDrawer() => BasicDrawer(currentRoute: routeName);

  @override
  Widget buildFloatingButton(BuildContext c, NotesManager manager) =>
      FloatingActionButton(
        onPressed: manager.create,
        tooltip: t(c, 'actions.add'),
        child: new Icon(Icons.add),
      );

  @override
  NotesManager createManager() => NotesManagerImpl();
}
