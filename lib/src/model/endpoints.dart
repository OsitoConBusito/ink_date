class Endpoints {
  Endpoints({required this.loginUrl});

  factory Endpoints.fromMap(Map<String, dynamic> map) => Endpoints(
        loginUrl: map[_AttributeKeys.loginUrl].toString(),
      );

  final String loginUrl;
}

abstract class _AttributeKeys {
  static const String loginUrl = 'loginUrl';
}
