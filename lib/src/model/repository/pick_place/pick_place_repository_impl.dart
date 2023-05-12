import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import '../model/tattooist.dart';
import 'pick_place_repository.dart';

class PickPlaceRepositoryImpl extends PickPlaceRepository {
  PickPlaceRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, int?>> getPlaces() async {
    try {
      final Tattooist? tattooist = await _secureStorage.getTattooistData();

      if (tattooist == null) {
        return const Right<Failure, int?>(null);
      }

      final DocumentSnapshot<Map<String, dynamic>> data =
          await _firebaseFirestore
              .collection('admins')
              .doc(tattooist.studioId)
              .get();

      final Admin admin = Admin.fromMap(data.data()!);
      return Right<Failure, int?>(admin.numberOfPlaces);
    } on FirebaseException catch (error) {
      return Left<Failure, int?>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }
}
