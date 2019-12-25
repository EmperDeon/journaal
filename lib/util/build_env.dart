abstract class BuildEnv {
  bool debug;
  String initialRoute;
}

class DebugBuildEnv extends BuildEnv {
  DebugBuildEnv() {
    debug = true;
    initialRoute = '/';
  }
}

class ReleaseBuildEnv extends BuildEnv {
  ReleaseBuildEnv() {
    debug = false;
    initialRoute = '/';
  }
}
