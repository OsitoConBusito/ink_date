import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/ink_date.dart';
import 'ink_date_repository.dart';

class InkDateRepositoryImpl implements InkDateRepository {
  InkDateRepositoryImpl({
    required SecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, String>> saveInkDate(
      {required InkDate inkDate}) async {
    try {
      final Map<String, dynamic> inkDateStorage = InkDate.toMap(inkDate);
      await _secureStorage.saveInkDate(inkDateStorage);
      return const Right<Failure, String>('ok');
    } catch (e) {
      return Left<Failure, String>(
        Failure(error: AppError.serverError),
      );
    }
  }

  @override
  Future<Either<Failure, InkDate?>> getInkDate() async {
    try {
      final InkDate? inkDate = await _secureStorage.getInkDate();
      if (inkDate != null) {
        return Right<Failure, InkDate?>(inkDate);
      } else {
        return const Right<Failure, InkDate?>(null);
      }
    } catch (e) {
      return Left<Failure, InkDate?>(
        Failure(error: AppError.serverError),
      );
    }
  }
}
