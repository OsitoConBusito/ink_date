class Admin {
  Admin({
    required this.deviceId,
    required this.email,
    required this.fullName,
    required this.id,
    required this.numberOfPlaces,
    required this.placeName,
    this.placePicture,
    this.profilePicture,
  });

  factory Admin.fromMap(Map<String, dynamic> map) => Admin(
        deviceId: map[_AttributeKeys.deviceId].toString(),
        email: map[_AttributeKeys.email].toString(),
        fullName: map[_AttributeKeys.fullName].toString(),
        id: map[_AttributeKeys.id].toString(),
        numberOfPlaces: map[_AttributeKeys.numberOfPlaces] as int,
        placeName: map[_AttributeKeys.placeName].toString(),
        placePicture: map[_AttributeKeys.placePicture]?.toString(),
        profilePicture: map[_AttributeKeys.profilePicture]?.toString(),
      );

  final String deviceId;
  String email;
  String fullName;
  final String id;
  int numberOfPlaces;
  final String placeName;
  String? placePicture;
  String? profilePicture;

  static Map<String, dynamic> toMap(Admin admin) => <String, dynamic>{
        _AttributeKeys.deviceId: admin.deviceId,
        _AttributeKeys.email: admin.email,
        _AttributeKeys.fullName: admin.fullName,
        _AttributeKeys.id: admin.id,
        _AttributeKeys.numberOfPlaces: admin.numberOfPlaces,
        _AttributeKeys.placeName: admin.placeName,
        _AttributeKeys.placePicture: admin.placePicture,
        _AttributeKeys.profilePicture: admin.profilePicture,
      };
}

abstract class _AttributeKeys {
  static const String deviceId = 'deviceId';
  static const String email = 'email';
  static const String fullName = 'fullName';
  static const String id = 'id';
  static const String numberOfPlaces = 'numberOfPlaces';
  static const String placeName = 'placeName';
  static const String placePicture = 'placePicture';
  static const String profilePicture = 'profilePicture';
}
