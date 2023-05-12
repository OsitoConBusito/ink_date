import 'package:dartz/dartz.dart';

import '../../failure.dart';

abstract class DetailInkDateRepository {
  Future<Either<Failure, bool?>> cancelInkDate({
    required String id,
    required String observations,
  });
}
