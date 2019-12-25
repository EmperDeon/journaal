import 'package:flutter/material.dart';
import 'package:journal/managers/settings.dart';
import 'package:journal/screens/components/basic_drawer.dart';
import 'package:journal/screens/components/fields/dropdown.dart';
import 'package:journal/screens/components/fields/switch.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/base.dart';
import 'package:journal/screens/components/section.dart';

class SettingsScreen extends BaseScreen<SettingsManager> {
  static const String routeName = '/settings';
  static const List<String> languages = ['en', 'ru'];
  static const List<String> passwordModes = ['none', 'password', 'pin'];

  SettingsScreen({Key key}) : super(titleTr: 'screens.settings', key: key);

  @override
  Widget buildContent(BuildContext c, SettingsManager manager) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        children: <Widget>[
          Section(
            titleTr: 'setting.security',
            topPadding: 0,
            leftPadding: 0,
            child: Column(
              children: <Widget>[
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
                StreamBuilder(
                  stream: manager.updatePasswordMode,
                  initialData: manager.passwordMode ?? passwordModes.first,
                  builder: (_, snap) => RxSwitchField(
                    titleTr: 'setting.autoUnlock',
                    enabled: snap.data != 'none',
                    value: manager.autoUnlock,
                    valueCommand: manager.updateAutoUnlock,
                  ),
                ),
              ],
            ),
          ),
          Section(
            titleTr: 'setting.other',
            leftPadding: 0,
            child: Column(
              children: <Widget>[
                RxDropdownField(
                  dataSource: languages,
                  value: manager.locale ?? languages.first,
                  valueCommand: manager.updateLocale,
                  titleTr: 'setting.language',
                  prefixTr: 'setting.languages.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Actions for AppBar
  @override
  List<Widget> buildActions(BuildContext c, SettingsManager manager) => [
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: t(c, 'actions.save'),
          onPressed: manager.save,
        ),
      ];

  // Screen Drawer
  @override
  BasicDrawer buildDrawer() => BasicDrawer(currentRoute: routeName);

  @override
  SettingsManager createManager() => SettingsManagerImpl();
}
