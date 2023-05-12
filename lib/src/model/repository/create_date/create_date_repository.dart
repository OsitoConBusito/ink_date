import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/customer.dart';
import '../model/ink_date.dart';

abstract class CreateDateRepository {
  Future<Either<Failure, DocumentReference<Map<String, dynamic>>>> saveInkDate(
      {required InkDate inkDate});

  Future<Either<Failure, DocumentReference<Map<String, dynamic>>>> saveCustomer(
      {required Customer customer});

  Future<Either<Failure, bool>> updateTattooistListInkDates(String idInkDate);

  Future<Either<Failure, bool>> deleteInkDate();
}
