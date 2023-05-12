import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/ink_date.dart';

abstract class InkDateRepository {
  Future<Either<Failure, String>> saveInkDate({required InkDate inkDate});

  Future<Either<Failure, InkDate?>> getInkDate();
}
