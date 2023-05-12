class Tattooist {
  Tattooist({
    this.datesId,
    required this.deviceId,
    required this.email,
    required this.fullName,
    this.profilePicture,
    required this.studioEmail,
    required this.studioId,
    required this.studioName,
    required this.studioPicture,
  });

  factory Tattooist.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? inkDates =
        map[_AttributeKeys.datesId] as List<dynamic>?;
    if (inkDates != null) {
      final List<String> inkDateId =
          inkDates.map((dynamic e) => e.toString()).toList();
      return Tattooist(
        datesId: inkDateId,
        deviceId: map[_AttributeKeys.deviceId].toString(),
        email: map[_AttributeKeys.email].toString(),
        fullName: map[_AttributeKeys.fullName].toString(),
        profilePicture: map[_AttributeKeys.profilePicture]?.toString(),
        studioEmail: map[_AttributeKeys.studioEmail].toString(),
        studioId: map[_AttributeKeys.studioId].toString(),
        studioName: map[_AttributeKeys.studioName].toString(),
        studioPicture: map[_AttributeKeys.studioPicture].toString(),
      );
    } else {
      return Tattooist(
        datesId: map[_AttributeKeys.datesId] as List<String>?,
        deviceId: map[_AttributeKeys.deviceId].toString(),
        email: map[_AttributeKeys.email].toString(),
        fullName: map[_AttributeKeys.fullName].toString(),
        profilePicture: map[_AttributeKeys.profilePicture]?.toString(),
        studioEmail: map[_AttributeKeys.studioEmail].toString(),
        studioId: map[_AttributeKeys.studioId].toString(),
        studioName: map[_AttributeKeys.studioName].toString(),
        studioPicture: map[_AttributeKeys.studioPicture].toString(),
      );
    }
  }

  List<String>? datesId;
  final String deviceId;
  String email;
  String fullName;
  String? profilePicture;
  String studioEmail;
  String studioId;
  String studioName;
  String? studioPicture;

  static Map<String, dynamic> toMap(Tattooist tattooist) => <String, dynamic>{
        _AttributeKeys.datesId: tattooist.datesId,
        _AttributeKeys.deviceId: tattooist.deviceId,
        _AttributeKeys.email: tattooist.email,
        _AttributeKeys.fullName: tattooist.fullName,
        _AttributeKeys.profilePicture: tattooist.profilePicture,
        _AttributeKeys.studioEmail: tattooist.studioEmail,
        _AttributeKeys.studioId: tattooist.studioId,
        _AttributeKeys.studioName: tattooist.studioName,
        _AttributeKeys.studioPicture: tattooist.studioPicture,
      };
}

abstract class _AttributeKeys {
  static const String datesId = 'datesId';
  static const String deviceId = 'deviceId';
  static const String email = 'email';
  static const String fullName = 'fullName';
  static const String profilePicture = 'profilePicture';
  static const String studioEmail = 'studioEmail';
  static const String studioId = 'studioId';
  static const String studioName = 'studioName';
  static const String studioPicture = 'studioPicture';
}
