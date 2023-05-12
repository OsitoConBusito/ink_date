import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../model/admin.dart';
import '../model/tattooist.dart';
import 'sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  SignUpRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  static const String adminsDatabase = 'admins';
  static const String email = 'email';
  static const String tattooistsDatabase = 'tattooists';

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<Either<Failure, bool>> saveAdminData(Admin admin) async {
    try {
      await _firebaseFirestore
          .collection(adminsDatabase)
          .doc(_firebaseAuth.currentUser!.uid)
          .set(Admin.toMap(admin));
      return const Right<Failure, bool>(true);
    } on FirebaseException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> saveTattooistData(Tattooist tattooist) async {
    try {
      await _firebaseFirestore
          .collection(tattooistsDatabase)
          .doc(_firebaseAuth.currentUser!.uid)
          .set(Tattooist.toMap(tattooist));
      return const Right<Failure, bool>(true);
    } on FirebaseException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right<Failure, User>(userCredential.user!);
    } on FirebaseException catch (error) {
      return Left<Failure, User>(
        Failure(
          error: AppError.firebaseAuthError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Admin>> studioEmailExist(String studioEmail) async {
    try {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>>
          studioEmailQueryResponse = (await _firebaseFirestore
                  .collection(adminsDatabase)
                  .where(email, isEqualTo: studioEmail)
                  .get())
              .docs;

      if (studioEmailQueryResponse.isNotEmpty) {
        return Right<Failure, Admin>(
            Admin.fromMap(studioEmailQueryResponse.first.data()));
      } else {
        return Left<Failure, Admin>(
          Failure(
              error: AppError.firebaseFirestoreError,
              description: 'Studio email not found'),
        );
      }
    } on FirebaseException catch (error) {
      return Left<Failure, Admin>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }
}
