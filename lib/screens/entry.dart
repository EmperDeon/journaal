import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/entry.dart';
import 'package:journal/screens/components/managed_widget.dart';
import 'package:journal/screens/components/rx_text_field.dart';
import 'package:journal/services.dart';

class EntryScreen extends ManagedWidget<EntryManager> {
  EntryScreen(String entryId, {Key key})
      : super(sl<EntryManager>(), argument: entryId, key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: StreamBuilder(
          stream: manager.title.valueStream,
          initialData: '',
          builder: (_, snap) => Text(snap.data),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: manager.save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: <Widget>[
            RxTextField(
              manager.title,
              decoration: InputDecoration(labelText: 'Name'),
              maxLines: 1,
            ),
            RxTextField(
              manager.body,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
