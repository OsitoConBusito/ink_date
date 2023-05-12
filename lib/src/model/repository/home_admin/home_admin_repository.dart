import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/custom_ink_date.dart';

abstract class HomeAdminRepository {
  Future<Either<Failure, List<CustomInkDate>?>> getInkDates();
}
