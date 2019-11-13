abstract class BuildEnv {
  bool debug;
}

class DebugBuildEnv extends BuildEnv {
  DebugBuildEnv() {
    debug = true;
  }
}

class ReleaseBuildEnv extends BuildEnv {
  ReleaseBuildEnv() {
    debug = false;
  }
}
