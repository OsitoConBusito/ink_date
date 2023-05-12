import 'customer.dart';

class InkDate {
  InkDate({
    required this.adminId,
    required this.client,
    required this.clientId,
    required this.currentPlace,
    required this.endDate,
    this.observations,
    this.isCanceled = false,
    required this.moreDetails,
    required this.startDate,
    required this.tattooistId,
  });

  factory InkDate.fromMap(Map<String, dynamic> map) => InkDate(
        adminId: map[_AttributeKeys.adminId].toString(),
        client: Customer.fromMap(
            map[_AttributeKeys.client] as Map<String, dynamic>),
        clientId: map[_AttributeKeys.clientId].toString(),
        currentPlace: int.parse(map[_AttributeKeys.currentPlace].toString()),
        endDate: DateTime.parse(map[_AttributeKeys.endDate].toString()),
        isCanceled:
            map[_AttributeKeys.isCanceled].toString().toLowerCase() == 'true',
        moreDetails: map[_AttributeKeys.moreDetails].toString(),
        observations: map[_AttributeKeys.observations].toString(),
        startDate: DateTime.parse(map[_AttributeKeys.startDate].toString()),
        tattooistId: map[_AttributeKeys.tattooistId].toString(),
      );

  String adminId;
  Customer client;
  String clientId;
  int currentPlace;
  DateTime endDate;
  bool isCanceled;
  String? moreDetails;
  String? observations;
  DateTime startDate;
  String tattooistId;

  static List<InkDate> fromDynamicList(List<Map<String, dynamic>> list) {
    final List<InkDate> result = <InkDate>[];

    if (list != null) {
      for (final Map<String, dynamic> map in list) {
        result.add(InkDate.fromMap(map));
      }
    }
    return result;
  }

  static Map<String, dynamic> toMap(InkDate inkDate) => <String, dynamic>{
        _AttributeKeys.adminId: inkDate.adminId,
        _AttributeKeys.client: Customer.toMap(inkDate.client),
        _AttributeKeys.clientId: inkDate.clientId,
        _AttributeKeys.currentPlace: inkDate.currentPlace,
        _AttributeKeys.endDate: inkDate.endDate.toString(),
        _AttributeKeys.moreDetails: inkDate.moreDetails,
        _AttributeKeys.startDate: inkDate.startDate.toString(),
        _AttributeKeys.tattooistId: inkDate.tattooistId,
      };

  static Map<String, dynamic> toFirebaseCollection(InkDate inkDate) =>
      <String, dynamic>{
        _AttributeKeys.adminId: inkDate.adminId,
        _AttributeKeys.clientId: inkDate.clientId,
        _AttributeKeys.currentPlace: inkDate.currentPlace,
        _AttributeKeys.endDate: inkDate.endDate.toString(),
        _AttributeKeys.isCanceled: inkDate.isCanceled,
        _AttributeKeys.moreDetails: inkDate.moreDetails,
        _AttributeKeys.observations: inkDate.observations,
        _AttributeKeys.startDate: inkDate.startDate.toString(),
        _AttributeKeys.tattooistId: inkDate.tattooistId,
      };
}

abstract class _AttributeKeys {
  static const String adminId = 'adminId';
  static const String client = 'client';
  static const String clientId = 'clientId';
  static const String currentPlace = 'currentPlace';
  static const String observations = 'observations';
  static const String endDate = 'endDate';
  static const String isCanceled = 'isCanceled';
  static const String moreDetails = 'moreDetails';
  static const String startDate = 'startDate';
  static const String tattooistId = 'tattooistId';
}
