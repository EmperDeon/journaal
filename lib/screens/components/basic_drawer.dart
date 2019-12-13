import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:journal/screens/components/i18n/text.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';

/// Drawer for navigation
class BasicDrawer extends StatelessWidget {
  final Function() _beforeNavigateCallback;
  final String currentRoute;

  BasicDrawer({this.currentRoute, Function() beforeNavigateCallback})
      : _beforeNavigateCallback = beforeNavigateCallback ?? (() => null);

  @override
  Widget build(BuildContext c) {
    ThemeData theme = Theme.of(c);
    TextStyle titleTheme = theme.textTheme.display3.apply(color: Colors.white);
    TextStyle footerText = theme.textTheme.body1.apply(fontWeightDelta: -2);

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: TextTr(
                    'app.name',
                    style: titleTheme,
                    // textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                  ),
                ),
                buildTile('screens.notes', '/', Icons.list),
                buildTile('screens.journals', '/journals', Icons.format_list_numbered),
                buildTile('screens.settings', '/settings', Icons.settings),
              ],
            ),
          ),
          buildFooter(footerText),
        ],
      ),
    );
  }

  Widget buildTile(String key, String path, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: TextTr(key),
      onTap: () => navigateTo(path),
      selected: path == currentRoute,
    );
  }

  Widget buildFooter(TextStyle textStyle) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: TextTr(
              'app.version',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: GetVersion.projectVersion,
              builder: (_, snap) => Text(
                snap.data ?? '',
                textAlign: TextAlign.right,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateTo(String name) {
    sl<NavigationService>().pop();

    if (name == currentRoute) {
      return;
    }

    _beforeNavigateCallback();
    sl<NavigationService>().replaceWith(name);
  }
}
