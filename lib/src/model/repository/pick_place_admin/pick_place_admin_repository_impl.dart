import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import 'pick_place_admin_repository.dart';

class PickPlaceAdminRepositoryImpl extends PickPlaceAdminRepository {
  PickPlaceAdminRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, int?>> getPlaces() async {
    try {
      final Admin? admin = await _secureStorage.getAdminData();

      if (admin == null) {
        return const Right<Failure, int?>(null);
      }

      final DocumentSnapshot<Map<String, dynamic>> data =
          await _firebaseFirestore.collection('admins').doc(admin.id).get();

      final Admin adminResponse = Admin.fromMap(data.data()!);
      return Right<Failure, int?>(adminResponse.numberOfPlaces);
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
