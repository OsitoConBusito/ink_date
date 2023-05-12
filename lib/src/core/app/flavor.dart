enum Flavor {
  develop,
  stage,
  master,
}

extension FlavorExtension on Flavor {
  static const String developConfigFile = 'assets/config/develop_config.json';
  static const String stageConfigFile = 'assets/config/stage_config.json';
  static const String masterConfigFile = 'assets/config/master_config.json';

  String get configFile {
    switch (this) {
      case Flavor.develop:
        return developConfigFile;
      case Flavor.stage:
        return stageConfigFile;
      case Flavor.master:
        return masterConfigFile;
    }
  }
}
