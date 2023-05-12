class Customer {
  Customer({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.studioId,
    required this.tattooistId,
  });

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
        email: map[_AttributeKeys.email].toString(),
        fullName: map[_AttributeKeys.fullName].toString(),
        phoneNumber: map[_AttributeKeys.phoneNumber].toString(),
        studioId: map[_AttributeKeys.studioId].toString(),
        tattooistId: map[_AttributeKeys.tattooistId].toString(),
      );

  final String email;
  final String fullName;
  final String phoneNumber;
  String studioId;
  String tattooistId;

  static Map<String, dynamic> toMap(Customer client) => <String, dynamic>{
        _AttributeKeys.email: client.email,
        _AttributeKeys.fullName: client.fullName,
        _AttributeKeys.phoneNumber: client.phoneNumber,
        _AttributeKeys.studioId: client.studioId,
        _AttributeKeys.tattooistId: client.tattooistId,
      };
}

abstract class _AttributeKeys {
  static const String email = 'email';
  static const String fullName = 'fullName';
  static const String phoneNumber = 'phoneNumber';
  static const String studioId = 'studioId';
  static const String tattooistId = 'tattooistId';
}
