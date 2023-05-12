import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../../storage/secure_storage_exception.dart';
import '../sign_up/sign_up_repository_impl.dart';
import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  static const String EMAIL = 'email';

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, bool>> getUserData(String email) async {
    late List<QueryDocumentSnapshot<Map<String, dynamic>>> userResponse;
    try {
      userResponse = (await _firebaseFirestore
              .collection(SignUpRepositoryImpl.tattooistsDatabase)
              .where(EMAIL, isEqualTo: email)
              .get())
          .docs;
      if (userResponse.isEmpty) {
        userResponse = (await _firebaseFirestore
                .collection(SignUpRepositoryImpl.adminsDatabase)
                .where(EMAIL, isEqualTo: email)
                .get())
            .docs;
      }
      _secureStorage.saveUserData(userResponse.first.data());
      return const Right<Failure, bool>(true);
    } on FirebaseException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    } on SecureStorageException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.localStorageError,
          description: error.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right<Failure, UserCredential>(userCredential);
    } on FirebaseAuthException catch (error) {
      return Left<Failure, UserCredential>(
        Failure(
          error: AppError.firebaseAuthError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> sendEmailToRecoverPassword(
      {required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return const Right<Failure, bool>(true);
    } on FirebaseAuthException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.firebaseAuthError,
          description: error.code,
        ),
      );
    }
  }
}
