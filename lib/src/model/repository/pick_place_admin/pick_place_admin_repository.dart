import 'package:dartz/dartz.dart';

import '../../failure.dart';

abstract class PickPlaceAdminRepository {
  Future<Either<Failure, int?>> getPlaces();
}
