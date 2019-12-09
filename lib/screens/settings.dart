import 'package:flutter/material.dart';
import 'package:journal/managers/settings.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/components/fields/dropdown.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/components/i18n/icon_button.dart';
import 'package:journal/screens/components/i18n/text.dart';
import 'package:journal/screens/base.dart';

class SettingsScreen extends BaseScreen<SettingsManager> {
  static const String routeName = '/settings';
  static const List<String> languages = ['en', 'ru'];
  static const List<String> passwordModes = ['none', 'password', 'pin'];

  SettingsScreen({Key key}) : super(titleTr: 'screens.settings', key: key);

  @override
  Widget buildContent(BuildContext c, SettingsManager manager) {
    ThemeData theme = Theme.of(c);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        children: <Widget>[
          TextTr('setting.security', style: theme.textTheme.title),
          RxDropdownField(
            dataSource: passwordModes,
            value: manager.passwordMode ?? passwordModes.first,
            valueCommand: manager.updatePasswordMode,
            titleTr: 'setting.passwordMode',
            prefixTr: 'setting.passwordModes.',
          ),
          StreamBuilder(
            stream: manager.updatePasswordMode,
            initialData: manager.passwordMode ?? passwordModes.first,
            builder: (_, snap) => RxTextField(
              manager.passwordField,
              titleTr: 'setting.password',
              obscureText: true,
              enabled: snap.data != 'none',
              keyboardType: snap.data == 'pin'
                  ? TextInputType.number
                  : TextInputType.visiblePassword,
            ),
          ),
          Container(height: 32),
          TextTr(
            'setting.other',
            style: theme.textTheme.title,
          ),
          RxDropdownField(
            dataSource: languages,
            value: manager.locale ?? languages.first,
            valueCommand: manager.updateLocale,
            titleTr: 'setting.language',
            prefixTr: 'setting.languages.',
          ),
        ],
      ),
    );
  }

  // Actions for AppBar
  @override
  List<Widget> buildActions(BuildContext c, SettingsManager manager) => [
        IconButtonTr(
          icon: const Icon(Icons.save),
          tooltip: 'actions.save',
          onPressed: manager.save,
        ),
      ];

  // Screen Drawer
  @override
  BasicDrawer buildDrawer() => BasicDrawer(currentRoute: routeName);

  @override
  SettingsManager createManager() => SettingsManagerImpl();
}
