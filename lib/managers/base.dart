import 'package:flutter/material.dart';

class BaseManager {
  ScaffoldState scaffold;

  void setScaffold(ScaffoldState scaffoldKey) {
    scaffold = scaffoldKey;
  }

  void showSnackBar(SnackBar bar) {
    scaffold.showSnackBar(bar);
  }
}
