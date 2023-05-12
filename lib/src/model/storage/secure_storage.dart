import '../repository/model/admin.dart';
import '../repository/model/ink_date.dart';
import '../repository/model/noti_scheluder.dart';
import '../repository/model/tattooist.dart';

abstract class SecureStorage {
  Future<void> changeTheme({
    required bool isDarkMode,
  });

  Future<Admin?> getAdminData();

  Future<bool> isDarkMode();

  Future<bool> logout();

  Future<InkDate?> getInkDate();

  Future<Tattooist?> getTattooistData();

  Future<NotiScheduled?> getNotiScheduled();

  Future<void> deleteInkDate();

  Future<void> savedInfoDay(Map<String, dynamic> notiScheduled);

  Future<void> saveInkDate(Map<String, dynamic> inkDate);

  Future<void> saveUserData(Map<String, dynamic> userData);
}
