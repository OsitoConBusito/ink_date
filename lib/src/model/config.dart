import 'endpoints.dart';

class Config {
  Config({required this.endpoints});

  factory Config.fromMap(Map<String, dynamic> map) => Config(
        endpoints: Endpoints.fromMap(
            map[_AttributesKeys.endpoints] as Map<String, dynamic>),
      );

  final Endpoints endpoints;
}

abstract class _AttributesKeys {
  static const String endpoints = 'endpoints';
}
