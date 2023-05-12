import 'app_error.dart';

abstract class AppException implements Exception {
  AppException({this.message});

  final String? message;

  AppError get error;
}
