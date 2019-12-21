import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/journal.dart';
import 'package:journal/screens/components/fields/datetime.dart';
import 'package:journal/screens/components/fields/icon_selector.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/base.dart';
import 'package:journal/screens/components/section.dart';
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
          RxDateTimeField(
            manager.date,
            titleTr: 'journal.date',
          ),
          buildEntries(c, manager),
        ],
      ),
    );
  }

  Widget buildEntries(BuildContext c, JournalManager manager) => StreamBuilder(
      stream: manager.entriesStream,
      initialData: [],
      builder: (_, snap) {
        return Column(
          children: List.castFrom<dynamic, Widget>(flattenL(
            snap.data
                .asMap()
                .map((index, fManager) =>
                    MapEntry(index, buildEntry(c, manager, index, fManager)))
                .values
                .toList(),
          )),
        );
      });

  Widget buildEntry(BuildContext c, JournalManager manager, int index,
          JournalEntryManager fManager) =>
      Section(
        title: t(c, 'journal.entry', args: {'num': (index + 1).toString()}),
        child: Column(
          children: <Widget>[
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
            RxIconSelector(
              command: fManager.updateRating,
              initial: fManager.rating,
              icons: JournalManager.ratingIcons,
              iconSize: 20,
            )
          ],
        ),
        buttons: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: t(c, 'actions.delete'),
            onPressed: () => manager.destroyEntry(index),
          )
        ],
      );

  // Actions for AppBar
  @override
  List<Widget> buildActions(BuildContext c, JournalManager manager) => [
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

  // Floating button
  @override
  Widget buildFloatingButton(BuildContext c, JournalManager manager) =>
      FloatingActionButton(
        onPressed: manager.appendEntry,
        tooltip: t(c, 'actions.add'),
        child: Icon(Icons.add),
      );

  @override
  JournalManager createManager() => JournalManagerImpl(this.journalId);
}
