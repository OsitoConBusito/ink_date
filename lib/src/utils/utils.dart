import '../model/repository/model/custom_ink_date.dart';

enum MonthName {
  Enero,
  Febrero,
  Marzo,
  Abril,
  Mayo,
  Junio,
  Julio,
  Agosto,
  Septiembre,
  Octubre,
  Noviembre,
  Diciembre
}

class Utils {
  Utils._();

  static String dateToString(int convert) {
    return convert.toString().length == 2
        ? convert.toString().padRight(3, ':00')
        : convert.toString().padLeft(2, '0').padRight(3, ':00');
  }

  static String inkDateHour(CustomInkDate detailInkDate) {
    final String startDate = detailInkDate.startDate.hour > 12
        ? '${detailInkDate.startDate.hour} P.M'
        : '${detailInkDate.startDate.hour} A.M';
    final String endDate = detailInkDate.endDate.hour > 12
        ? '${detailInkDate.endDate.hour} P.M'
        : '${detailInkDate.endDate.hour} A.M';
    return '$startDate - $endDate';
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(password);
  }

  static String? userNameFromEmail(String email) {
    return RegExp('([^@]+)').firstMatch(email)?[0];
  }

  static String monthActuality(int month) {
    switch (month) {
      case 1:
        return MonthName.Enero.name;
      case 2:
        return MonthName.Febrero.name;
      case 3:
        return MonthName.Marzo.name;
      case 4:
        return MonthName.Abril.name;
      case 5:
        return MonthName.Mayo.name;
      case 6:
        return MonthName.Junio.name;
      case 7:
        return MonthName.Julio.name;
      case 8:
        return MonthName.Agosto.name;
      case 9:
        return MonthName.Septiembre.name;
      case 10:
        return MonthName.Octubre.name;
      case 11:
        return MonthName.Noviembre.name;
      case 12:
        return MonthName.Diciembre.name;
    }
    return '';
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
