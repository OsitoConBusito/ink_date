import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/admin.dart';
import '../model/custom_ink_date.dart';
import '../model/tattooist.dart';

abstract class HomeRepository {
  Future<Either<Failure, Admin>> getAdminData();

  Future<Either<Failure, List<CustomInkDate>?>> getInkDates();

  Future<Either<Failure, Tattooist>> getTattooistData();
}
