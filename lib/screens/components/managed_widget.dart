import 'package:flutter/widgets.dart';
import 'package:journal/managers/base.dart';

abstract class ManagedWidget<T extends BaseManager> extends StatefulWidget {
  final T manager;
  final dynamic argument;

  ManagedWidget(this.manager, {this.argument, Key key}) : super(key: key);

  Widget build(BuildContext context);

  @override
  State<StatefulWidget> createState() => ManagedWidgetState<T>();
}

class ManagedWidgetState<T> extends State<ManagedWidget> {
  @override
  void initState() {
    widget.manager.reset(widget.argument);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
