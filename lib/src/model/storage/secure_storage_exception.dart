import '../../core/app/app_error.dart';
import '../../core/app/app_exception.dart';

class SecureStorageException extends AppException {
  SecureStorageException({String? message}) : super(message: message);

  @override
  AppError get error => AppError.serverError;
}
