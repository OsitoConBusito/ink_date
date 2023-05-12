import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

import '../repository/model/admin.dart';
import '../repository/model/ink_date.dart';
import '../repository/model/noti_scheluder.dart';
import '../repository/model/tattooist.dart';
import 'secure_storage.dart';
import 'secure_storage_exception.dart';

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl() : _flutterSecureStorage = const FlutterSecureStorage();

  final Logger _logger = Logger('SecureStorage');
  final FlutterSecureStorage _flutterSecureStorage;

  bool? _isDarkMode;

  @override
  Future<void> deleteInkDate() async {
    try {
      await _flutterSecureStorage.delete(key: _AttributesKeys.inkDate);
    } on SecureStorageException catch (e, stack) {
      _logger.severe(
          'Exception saving "$_AttributesKeys.inkDate" to secure storage',
          e,
          stack);
    }
  }

  @override
  Future<void> changeTheme({required bool isDarkMode}) async {
    await _save(
      key: _AttributesKeys.isDarkMode,
      value: isDarkMode.toString(),
    );

    _isDarkMode = isDarkMode;
  }

  @override
  Future<Admin?> getAdminData() async {
    final String? response = await _load(key: _AttributesKeys.userData);
    if (response != null) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response) as Map<String, dynamic>;
      if (jsonResponse['placeName'] != null) {
        return Admin.fromMap(json.decode(response) as Map<String, dynamic>);
      }
    }
    return null;
  }

  @override
  Future<Tattooist?> getTattooistData() async {
    final String? response = await _load(key: _AttributesKeys.userData);
    if (response != null) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response) as Map<String, dynamic>;
      if (jsonResponse['studioEmail'] != null) {
        return Tattooist.fromMap(json.decode(response) as Map<String, dynamic>);
      }
    }
    return null;
  }

  @override
  Future<InkDate?> getInkDate() async {
    final String? response = await _load(key: _AttributesKeys.inkDate);
    if (response != null) {
      return InkDate.fromMap(json.decode(response) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<bool> isDarkMode() async {
    if (_isDarkMode == null) {
      final String? rawDarkMode = await _load(
        key: _AttributesKeys.isDarkMode,
      );

      _isDarkMode = rawDarkMode == 'true';
    }

    return _isDarkMode!;
  }

  @override
  Future<void> saveInkDate(Map<String, dynamic> inkDate) async {
    await _save(
      key: _AttributesKeys.inkDate,
      value: json.encode(inkDate),
    );
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _save(
      key: _AttributesKeys.userData,
      value: json.encode(userData),
    );
  }

  Future<void> reset() async {
    try {
      await _flutterSecureStorage.deleteAll();
    } catch (e, stack) {
      _logger.severe('Exception clearing secure storage', e, stack);
    }
  }

  Future<String?> _load({
    required String key,
  }) async {
    String? result;

    try {
      result = await _flutterSecureStorage.read(key: key);
    } catch (e, stack) {
      _logger.severe('Exception loading "$key" from secure storage', e, stack);
    }
    return result;
  }

  Future<void> _save({
    required String key,
    String? value,
  }) async {
    try {
      if (value?.isNotEmpty != true) {
        await _flutterSecureStorage.delete(key: key);
      } else {
        await _flutterSecureStorage.write(
          key: key,
          value: value,
        );
      }
    } on SecureStorageException catch (e, stack) {
      _logger.severe('Exception saving "$key" to secure storage', e, stack);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _flutterSecureStorage.delete(key: _AttributesKeys.userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> savedInfoDay(Map<String, dynamic> notiScheduled) async {
    await _save(
      key: _AttributesKeys.infoScheduled,
      value: json.encode(notiScheduled),
    );
  }

  @override
  Future<NotiScheduled?> getNotiScheduled() async {
    final String? response = await _load(key: _AttributesKeys.infoScheduled);
    if (response != null) {
      return NotiScheduled.fromMap(
          json.decode(response) as Map<String, dynamic>);
    }
    return null;
  }
}

abstract class _AttributesKeys {
  static const String inkDate = 'inkDate';
  static const String isDarkMode = 'isDarkMode';
  static const String userData = 'userData';
  static const String infoScheduled = 'infoScheduled';
}
