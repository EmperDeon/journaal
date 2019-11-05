import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/models/entries_model.dart';
import 'package:journal/models/entry.dart';
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

  String _title, _body;
  final TextEditingController titleController = TextEditingController(),
                              bodyController = TextEditingController();

  void onSave() {
    Entry entry = model.getByIndex(index).copy();
    entry.title = titleController.text;
    entry.body = bodyController.text;
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
    Entry entry = model.getByIndex(index).copy();
    _title = entry.title;
    _body = entry.body;

    if (titleController.text.isEmpty) titleController.text = _title;
    if (bodyController.text.isEmpty) bodyController.text = _body;

    titleController.addListener(() {
      _title = titleController.text;
    });

    bodyController.addListener(() {
      _body = bodyController.text;
    });

    return widget.build(context, titleController, bodyController, onSave, _title, _body);
  }
}
