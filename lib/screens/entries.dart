import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/models/entries_model.dart';
import 'package:journal/models/entry.dart';
import 'package:provider/provider.dart';

class EntriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var entries = Provider.of<EntriesModel>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings')
          ),
        ],
      ),
      body: new Center(
        child: ListView.separated(
          itemCount: entries.length,
          itemBuilder: (_c, index) => _EntryItem(index),
          separatorBuilder: (_c, _i) => Divider()
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          entries.add();
        },
        tooltip: 'Add item',
        child: new Icon(Icons.add),
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  _EntryItem(this.index, {Key key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    EntriesModel model = Provider.of<EntriesModel>(context);
    Entry item = model.getByIndex(index);

    return ListTile(
      title: Text(item.title),
      onTap: () {
        Navigator.pushNamed(context, '/entry', arguments: index);
      }
    );
  }
}
