import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/entries.dart';
import 'package:journal/models/entry.dart';
import 'package:journal/screens/components/managed_widget.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';

class EntriesScreen extends ManagedWidget<EntriesManager> {
  EntriesScreen({Key key}) : super(sl<EntriesManager>(), key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: new Center(
        child: StreamBuilder(
          stream: manager.itemKeysStream,
          initialData: [],
          builder: (_, snapshot) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (_c, index) => buildTile(snapshot.data[index]),
              separatorBuilder: (_c, _i) => Divider(),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: manager.create,
        tooltip: 'Add item',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget buildTile(String id) {
    Entry entry = manager[id];

    return ListTile(
      title: Text(entry.title),
      onTap: () {
        sl<NavigationService>().navigateTo('/entry', arguments: id);
      },
    );
  }
}
