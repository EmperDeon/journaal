import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:journal/managers/app.dart';
import 'package:journal/screens/components/locking_builder.dart';
import 'package:journal/services.dart';
import 'package:journal/services/i18n.dart';
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
                  child: Text(
                    I18n.t(c, 'app.name'),
                    style: titleTheme,
                    // textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                  ),
                ),
                LockingBuilder(
                  enabledBuilder: (_) => buildActionTile(
                      c, 'actions.lock', sl<AppManager>().lock, Icons.lock),
                ),
                LockingBuilder(enabledBuilder: (_) => Divider()),
                buildRouteTile(c, 'screens.notes', '/', Icons.list),
                buildRouteTile(c, 'screens.journals', '/journal',
                    Icons.format_list_numbered),
                buildRouteTile(
                    c, 'screens.settings', '/settings', Icons.settings),
              ],
            ),
          ),
          buildFooter(c, footerText),
        ],
      ),
    );
  }

  Widget buildActionTile(
      BuildContext c, String key, Function() action, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(I18n.t(c, key)),
      onTap: action,
    );
  }

  Widget buildRouteTile(
      BuildContext c, String key, String path, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(I18n.t(c, key)),
      onTap: () => navigateTo(path),
      selected: path == currentRoute,
    );
  }

  Widget buildFooter(BuildContext c, TextStyle textStyle) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              I18n.t(c, 'app.version'),
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
