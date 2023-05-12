import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, bool>> getUserData(String email);

  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> sendEmailToRecoverPassword({
    required String email,
  });
}
