import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import 'detail_ink_date_repository.dart';

class DetailInkDateRepositoryImpl implements DetailInkDateRepository {
  DetailInkDateRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  static const String _kInkDates = 'inkDates';
  static const String _kIsCancel = 'isCanceled';
  static const String _kObersvations = 'observations';

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, bool?>> cancelInkDate({
    required String id,
    required String observations,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore.collection(_kInkDates).doc(id);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                _kIsCancel: true,
                _kObersvations: observations,
              },
            );
          }
        },
      );
      return const Right<Failure, bool?>(true);
    } on FirebaseException catch (error) {
      return Left<Failure, bool?>(
        Failure(
          description: error.code,
          error: AppError.firebaseFirestoreError,
        ),
      );
    }
  }
}
