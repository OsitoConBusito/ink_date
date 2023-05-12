import 'package:intl/intl.dart';

class NotiScheduled {
  NotiScheduled({
    required this.date,
    required this.quantity,
  });

  factory NotiScheduled.fromMap(Map<String, dynamic> map) => NotiScheduled(
        date: DateTime.parse(map[_AttributeKeys.date].toString()),
        quantity: int.parse(map[_AttributeKeys.quantity].toString()),
      );

  final DateTime date;
  final int quantity;

  static Map<String, dynamic> toMap(NotiScheduled notiScheduled) =>
      <String, dynamic>{
        _AttributeKeys.date:
            DateFormat('yyyy-MM-dd').format(notiScheduled.date),
        _AttributeKeys.quantity: notiScheduled.quantity.toString()
      };
}

abstract class _AttributeKeys {
  static const String date = 'date';
  static const String quantity = 'quantity';
}
