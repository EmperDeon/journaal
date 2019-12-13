import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/journal.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/components/i18n/icon_button.dart';
import 'package:journal/screens/base.dart';
import 'package:journal/screens/components/i18n/text.dart';
import 'package:journal/util/utils.dart';

class JournalScreen extends BaseScreen<JournalManager> {
  static const String routeName = '/journal';
  final String journalId;

  JournalScreen(this.journalId, {Key key})
      : super(titleTr: 'screens.journal', key: key);

  @override
  Widget buildContent(BuildContext c, JournalManager manager) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: '12313'),
          ),
          buildEntries(c, manager),
          RaisedButton(
            color: Colors.blue,
            child: TextTr('actions.add'),
            onPressed: manager.appendEntry,
          )
        ],
      ),
    );
  }

  Widget buildEntries(BuildContext c, JournalManager manager) {
    return StreamBuilder(
        stream: manager.entriesStream,
        initialData: [],
        builder: (_, snap) {
          print('Got ${snap.data}');
          return Column(
            children: List.castFrom<dynamic, Widget>(flattenL(
              snap.data
                  .map((fManager) => <Widget>[
                        Divider(
                          thickness: 1,
                          height: 32,
                        ),
                        RxTextField(
                          fManager.title,
                          titleTr: 'journal.name',
                          maxLines: 1,
                        ),
                        RxTextField(
                          fManager.body,
                          titleTr: 'journal.body',
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ])
                  .toList(),
            )),
          );
        });
  }

  // Actions for AppBar
  @override
  List<Widget> buildActions(BuildContext c, JournalManager manager) => [
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
  JournalManager createManager() => JournalManagerImpl(this.journalId);
}
