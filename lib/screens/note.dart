import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/note.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/base.dart';

class NoteScreen extends BaseScreen<NoteManager> {
  static const String routeName = '/note';
  final String noteId;

  NoteScreen(this.noteId, {Key key}) : super(titleTr: 'screens.note', key: key);

  @override
  Widget buildContent(BuildContext c, NoteManager manager) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        children: <Widget>[
          RxTextField(
            manager.title,
            titleTr: 'note.name',
            maxLines: 1,
          ),
          RxTextField(
            manager.body,
            titleTr: 'note.body',
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  // Actions for AppBar
  @override
  List<Widget> buildActions(BuildContext c, NoteManager manager) => [
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: t(c, 'actions.save'),
          onPressed: manager.save,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: t(c, 'actions.delete'),
          onPressed: manager.destroy,
        ),
      ];

  @override
  NoteManager createManager() => NoteManagerImpl(this.noteId);
}
