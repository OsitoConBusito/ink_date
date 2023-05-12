import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/customer.dart';
import '../model/ink_date.dart';
import '../model/tattooist.dart';
import '../sign_up/sign_up_repository_impl.dart';
import 'create_date_repository.dart';

class CreateDateRepositoryImpl implements CreateDateRepository {
  CreateDateRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  static const String inkDatesDatabase = 'inkDates';
  static const String customersDatabase = 'customers';

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;
  final FirebaseAuth _firebaseAuth;

  static const String DATES_ID = 'datesId';

  Future<void> _updateInkDatesTattooist({
    required List<String> inkDates,
  }) async {
    final Tattooist? tattooistData = await _secureStorage.getTattooistData();
    tattooistData!.datesId = inkDates;
    await _secureStorage.saveUserData(Tattooist.toMap(tattooistData));
  }

  @override
  Future<Either<Failure, DocumentReference<Map<String, dynamic>>>> saveInkDate(
      {required InkDate inkDate}) async {
    try {
      final Tattooist? tattooist = await _secureStorage.getTattooistData();

      if (tattooist == null) {
        return Left<Failure, DocumentReference<Map<String, dynamic>>>(
          Failure(
            error: AppError.localStorageError,
            description: 'Error tattooist',
          ),
        );
      }

      inkDate.adminId = tattooist.studioId;
      inkDate.tattooistId = _firebaseAuth.currentUser!.uid;

      final DocumentReference<Map<String, dynamic>> collectionInkDate =
          await _firebaseFirestore
              .collection(inkDatesDatabase)
              .add(InkDate.toFirebaseCollection(inkDate));
      return Right<Failure, DocumentReference<Map<String, dynamic>>>(
          collectionInkDate);
    } on FirebaseException catch (error) {
      return Left<Failure, DocumentReference<Map<String, dynamic>>>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DocumentReference<Map<String, dynamic>>>> saveCustomer(
      {required Customer customer}) async {
    try {
      final Tattooist? tattooist = await _secureStorage.getTattooistData();

      if (tattooist == null) {
        return Left<Failure, DocumentReference<Map<String, dynamic>>>(
          Failure(
            error: AppError.localStorageError,
            description: 'Error tattooist',
          ),
        );
      }

      customer.studioId = tattooist.studioId;
      customer.tattooistId = tattooist.deviceId;

      final DocumentReference<Map<String, dynamic>> collectionCustomer =
          await _firebaseFirestore
              .collection(customersDatabase)
              .add(Customer.toMap(customer));
      return Right<Failure, DocumentReference<Map<String, dynamic>>>(
          collectionCustomer);
    } on FirebaseException catch (error) {
      return Left<Failure, DocumentReference<Map<String, dynamic>>>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> updateTattooistListInkDates(
      String idInkDate) async {
    final Tattooist? tattooist = await _secureStorage.getTattooistData();
    if (tattooist == null) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.localStorageError,
          description: 'tattooist is null',
        ),
      );
    }
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.tattooistsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      if (tattooist.datesId == null) {
        final List<String> datesId = <String>[idInkDate];

        await documentReference.get().then(
          (DocumentSnapshot<Map<String, dynamic>> value) {
            if (value.exists) {
              documentReference.update(
                <String, dynamic>{
                  DATES_ID: datesId,
                },
              );
            }
          },
        );

        await _updateInkDatesTattooist(
          inkDates: datesId,
        );

        return const Right<Failure, bool>(true);
      }

      tattooist.datesId!.add(idInkDate);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                DATES_ID: tattooist.datesId,
              },
            );
          }
        },
      );
      await _updateInkDatesTattooist(
        inkDates: tattooist.datesId!,
      );

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

  @override
  Future<Either<Failure, bool>> deleteInkDate() async {
    try {
      await _secureStorage.deleteInkDate();
      return const Right<Failure, bool>(true);
    } catch (e) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.localStorageError,
          description: 'Error localStorage',
        ),
      );
    }
  }
}
