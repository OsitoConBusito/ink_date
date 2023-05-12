import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/custom_ink_date.dart';

abstract class PickDateRepository {
  Future<Either<Failure, List<CustomInkDate>?>> getInkDates();
}
