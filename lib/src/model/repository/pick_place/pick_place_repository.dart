import 'package:dartz/dartz.dart';

import '../../failure.dart';

abstract class PickPlaceRepository {
  Future<Either<Failure, int?>> getPlaces();
}
