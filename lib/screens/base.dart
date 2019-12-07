import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/base.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/components/i18n/text.dart';

abstract class BaseScreen<T extends BaseManager> extends StatefulWidget {
  // Title of screen
  final String title;

  // Translation key for screen title
  final String titleTr;

  BaseScreen({
    Key key,
    this.title,
    this.titleTr,
  }) : super(key: key);

  Widget _build(BuildContext context, T manager) {
    return new Scaffold(
      appBar: new AppBar(
        title: buildTitle(context, manager),
        actions: buildActions(context, manager),
      ),
      drawer: buildDrawer(),
      body: Builder(
        builder: (subContext) {
          manager.setScaffold(Scaffold.of(subContext));

          return buildContent(subContext, manager);
        },
      ),
      floatingActionButton: buildFloatingButton(context, manager),
    );
  }

  // Content for screen
  Widget buildContent(BuildContext context, T manager);

  // Title for screen
  Widget buildTitle(BuildContext context, T manager) => titleTr == null ? Text(title) : TextTr(titleTr);

  // Actions for AppBar
  List<Widget> buildActions(BuildContext context, T manager) => [];

  // Floating button
  Widget buildFloatingButton(BuildContext context, T manager) => null;

  // Screen Drawer
  BasicDrawer buildDrawer() => null;

  T createManager();

  @override
  State<StatefulWidget> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends BaseManager> extends State<BaseScreen> {
  T manager;

  @override
  void initState() {
    manager = widget.createManager();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget r = widget._build(context, manager);

    return r;
  }
}
