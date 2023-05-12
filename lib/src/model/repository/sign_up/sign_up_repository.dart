import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../failure.dart';
import '../model/admin.dart';
import '../model/tattooist.dart';

abstract class SignUpRepository {
  Future<Either<Failure, bool>> saveAdminData(Admin admin);

  Future<Either<Failure, bool>> saveTattooistData(Tattooist tattooist);

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, Admin>> studioEmailExist(String studioEmail);
}
