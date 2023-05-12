import 'customer.dart';
import 'tattooist.dart';

class CustomInkDate {
  CustomInkDate({
    required this.adminId,
    required this.currentPlace,
    required this.customer,
    required this.endDate,
    this.moreDetails,
    this.isCanceled = false,
    required this.id,
    required this.startDate,
    required this.tattooist,
    required this.idTattooist,
  });

  factory CustomInkDate.fromMap(Map<String, dynamic> map) => CustomInkDate(
        adminId: map[_AttributeKeys.adminId].toString(),
        currentPlace: int.parse(map[_AttributeKeys.currentPlace].toString()),
        customer: Customer.fromMap(
            map[_AttributeKeys.client] as Map<String, dynamic>),
        endDate: DateTime.parse(map[_AttributeKeys.endDate].toString()),
        id: map[_AttributeKeys.id].toString(),
        idTattooist: map[_AttributeKeys.idTattooist].toString(),
        isCanceled:
            map[_AttributeKeys.isCanceled].toString().toLowerCase() == 'true',
        moreDetails: map[_AttributeKeys.moreDetails].toString(),
        startDate: DateTime.parse(map[_AttributeKeys.startDate].toString()),
        tattooist: Tattooist.fromMap(
            map[_AttributeKeys.tattooist] as Map<String, dynamic>),
      );

  String id;
  String adminId;
  String? moreDetails;
  Customer customer;
  int currentPlace;
  DateTime endDate;
  bool isCanceled;
  DateTime startDate;
  Tattooist tattooist;
  String idTattooist;

  static List<CustomInkDate> fromDynamicList(List<Map<String, dynamic>> list) {
    final List<CustomInkDate> result = <CustomInkDate>[];

    if (list != null) {
      for (final Map<String, dynamic> map in list) {
        result.add(CustomInkDate.fromMap(map));
      }
    }
    return result;
  }

  static Map<String, dynamic> toMap(CustomInkDate inkDate) => <String, dynamic>{
        _AttributeKeys.adminId: inkDate.adminId,
        _AttributeKeys.client: Customer.toMap(inkDate.customer),
        _AttributeKeys.currentPlace: inkDate.currentPlace,
        _AttributeKeys.endDate: inkDate.endDate.toString(),
        _AttributeKeys.id: inkDate.id,
        _AttributeKeys.isCanceled: inkDate.isCanceled,
        _AttributeKeys.moreDetails: inkDate.moreDetails,
        _AttributeKeys.startDate: inkDate.startDate.toString(),
        _AttributeKeys.tattooist: Tattooist.toMap(inkDate.tattooist),
      };
}

abstract class _AttributeKeys {
  static const String adminId = 'adminId';
  static const String client = 'client';
  static const String currentPlace = 'currentPlace';
  static const String endDate = 'endDate';
  static const String id = 'id';
  static const String idTattooist = 'idTattooist';
  static const String isCanceled = 'isCanceled';
  static const String moreDetails = 'moreDetails';
  static const String startDate = 'startDate';
  static const String tattooist = 'tattooist';
}
