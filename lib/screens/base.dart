import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/base.dart';
import 'package:journal/presenters/snackbar.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/components/i18n/text.dart';
import 'package:journal/services/i18n.dart';

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

  // Content for screen
  Widget buildContent(BuildContext c, T manager);

  // Title for screen
  Widget buildTitle(BuildContext c, T manager) =>
      titleTr == null ? Text(title) : TextTr(titleTr);

  // Actions for AppBar
  List<Widget> buildActions(BuildContext c, T manager) => [];

  // Floating button
  Widget buildFloatingButton(BuildContext c, T manager) => null;

  // Screen Drawer
  BasicDrawer buildDrawer() => null;

  T createManager();

  //
  // Helper functions
  //

  Widget _build(BuildContext c, _BaseScreenState state) {
    return new Scaffold(
      key: state.scaffoldKey,
      appBar: new AppBar(
        title: buildTitle(c, state.manager),
        actions: buildActions(c, state.manager),
      ),
      drawer: buildDrawer(),
      body: Builder(
        builder: (c2) => buildContent(c2, state.manager),
      ),
      floatingActionButton: buildFloatingButton(c, state.manager),
    );
  }

  // Translate key
  String t(BuildContext c, String key,
          {Map<String, String> args, int plural}) =>
      I18n.t(c, key, args: args, plural: plural);

  String l(BuildContext c, String key, DateTime dateTime) =>
      I18n.l(c, key, dateTime);

  @override
  State<StatefulWidget> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends BaseManager> extends State<BaseScreen> {
  BaseManager manager;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    manager = widget.createManager();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    manager.scaffoldStream.listen((data) {
      if (data == null) return;

      if (data is SnackbarPresentation) presentSnackBar(context, data);
    });

    super.didChangeDependencies();
  }

  // Show snackbar
  void presentSnackBar(BuildContext c, SnackbarPresentation presentation) {
    scaffoldKey.currentState.showSnackBar(presentation.toBar(c));

    manager.presentToScaffold(null);
  }

  @override
  Widget build(BuildContext c) {
    Widget r = widget._build(context, this);

    return r;
  }
}
