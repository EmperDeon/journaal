import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/states/entries_notifier.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatefulWidget {
  Widget build(BuildContext context, TextEditingController titleController, TextEditingController bodyController, Function onSave, String title, String body) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              onSave();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(children: <Widget>[
            TextField(
              autofocus: true,
              maxLines: 1,
              controller: titleController
            ),
            Expanded(
              child: TextField(
                expands: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: bodyController
              )
            )
          ]
        )
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  EntriesModel model;
  int index;

  String title, body;
  final TextEditingController titleController = TextEditingController(),
                              bodyController = TextEditingController();

  void onSave() {
    Entry entry = model.getByIndex(index);
    entry.title = title;
    entry.body = body;
    model.setEntryAt(index, entry);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<EntriesModel>(context);
    index = ModalRoute.of(context).settings.arguments;
    Entry entry = model.getByIndex(index);
    title = entry.title;
    body = entry.body;

    if (titleController.text.isEmpty) titleController.text = title;
    if (bodyController.text.isEmpty) bodyController.text = body;

    titleController.addListener(() { title = titleController.text; });
    bodyController.addListener(() { body = bodyController.text; });

    return widget.build(context, titleController, bodyController, onSave, title, body);
  }
}
