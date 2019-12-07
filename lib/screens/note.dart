import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/note.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/components/i18n/icon_button.dart';
import 'package:journal/screens/base.dart';

class NoteScreen extends BaseScreen<NoteManager> {
  static const String routeName = '/note';
  final String noteId;

  NoteScreen(this.noteId, {Key key}) : super(titleTr: 'screens.note', key: key);

  @override
  Widget buildContent(BuildContext context, NoteManager manager) {
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
  List<Widget> buildActions(BuildContext context, NoteManager manager) => [
        IconButtonTr(
          icon: const Icon(Icons.save),
          tooltip: 'actions.save',
          onPressed: manager.save,
        ),
        IconButtonTr(
          icon: const Icon(Icons.delete),
          tooltip: 'actions.delete',
          onPressed: manager.destroy,
        ),
      ];

  @override
  NoteManager createManager() => NoteManagerImpl(this.noteId);
}
