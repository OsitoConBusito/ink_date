import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import '../model/tattooist.dart';
import '../sign_up/sign_up_repository_impl.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(
    this._firebaseAuth,
    this._firebaseFirestore,
    this._secureStorage,
  );

  static const String kEmailData = 'email';
  static const String kNameData = 'fullName';
  static const String kNumberPlaces = 'numberOfPlaces';
  static const String kProfilePicture = 'profilePicture';
  static const String kStudioEmailTattoist = 'studioEmail';
  static const String kStudioIdTattoist = 'studioId';
  static const String kStudioNameTattoist = 'studioName';
  static const String kStudioPicture = 'placePicture';
  static const String kStudioPictureTattoist = 'studioPicture';

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, bool>> sendEmailToChangesPassword(
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

  @override
  Future<Either<Failure, String>> updateAdminProfilePicture(
      {required String profilePictureUrl}) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.adminsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference
                .update(<String, dynamic>{kProfilePicture: profilePictureUrl});
          }
        },
      );

      await _updateUserData(profilePictureUrl);
      return Right<Failure, String>(profilePictureUrl);
    } catch (error) {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseFirestoreError),
      );
    }
  }

  Future<void> _updateUserData(String profilePictureUrl) async {
    final Admin? adminData = await _secureStorage.getAdminData();
    adminData!.profilePicture = profilePictureUrl;
    await _secureStorage.saveUserData(Admin.toMap(adminData));
  }

  Future<void> _updateUserDataAdmin({
    required int currentPlace,
    required String email,
    required String name,
  }) async {
    final Admin? adminData = await _secureStorage.getAdminData();
    adminData!.email = email;
    adminData.fullName = name;
    adminData.numberOfPlaces = currentPlace;
    await _secureStorage.saveUserData(Admin.toMap(adminData));
  }

  Future<void> _updateUSerDataTattoist({
    required String email,
    required String name,
  }) async {
    final Tattooist? tattooistData = await _secureStorage.getTattooistData();
    tattooistData!.email = email;
    tattooistData.fullName = name;
    await _secureStorage.saveUserData(Tattooist.toMap(tattooistData));
  }

  Future<void> _updateTattoistStudio({required Admin admin}) async {
    final Tattooist? tattooistData = await _secureStorage.getTattooistData();
    tattooistData!.studioEmail = admin.email;
    tattooistData.studioId = admin.id;
    tattooistData.studioName = admin.placeName;
    tattooistData.studioPicture = admin.placePicture;
    await _secureStorage.saveUserData(Tattooist.toMap(tattooistData));
  }

  Future<void> _updateUserDataTattooistPicture(String profilePictureUrl) async {
    final Tattooist? tattooistData = await _secureStorage.getTattooistData();
    tattooistData!.profilePicture = profilePictureUrl;
    await _secureStorage.saveUserData(Tattooist.toMap(tattooistData));
  }

  @override
  Future<Either<Failure, String>> updateAdminStudioPicture({
    required String studioPictureUrl,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.adminsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                kStudioPicture: studioPictureUrl,
              },
            );
          }
        },
      );
      await _updateUserData(studioPictureUrl);
      return Right<Failure, String>(studioPictureUrl);
    } catch (error) {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseFirestoreError),
      );
    }
  }

  @override
  Future<Either<Failure, String>> updateTattooistProfilePicture({
    required String tattooistPictureUrl,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.tattooistsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                kProfilePicture: tattooistPictureUrl,
              },
            );
          }
        },
      );
      await _updateUserDataTattooistPicture(tattooistPictureUrl);
      return Right<Failure, String>(tattooistPictureUrl);
    } catch (error) {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseFirestoreError),
      );
    }
  }

  @override
  Future<Either<Failure, String>> updateTattooistData({
    required String email,
    required String name,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.tattooistsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                kNameData: name,
                kEmailData: email,
              },
            );
          }
        },
      );
      await _updateUSerDataTattoist(
        email: email,
        name: name,
      );
      return Right<Failure, String>(email);
    } catch (error) {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseFirestoreError),
      );
    }
  }

  @override
  Future<Either<Failure, String>> updateAdminData({
    required int currentPlace,
    required String email,
    required String name,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.adminsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                kNameData: name,
                kEmailData: email,
                kNumberPlaces: currentPlace
              },
            );
          }
        },
      );
      await _updateUserDataAdmin(
        currentPlace: currentPlace,
        email: email,
        name: name,
      );
      return Right<Failure, String>(email);
    } catch (error) {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseFirestoreError),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadAdminProfilePicture({
    required String image,
    required String fileName,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(fileName);
      ref.putString(image, format: PutStringFormat.base64);
      final String downloadUrl = await ref.getDownloadURL();
      return Right<Failure, String>(downloadUrl);
    } on FirebaseException {
      return Left<Failure, String>(
        Failure(error: AppError.firebaseStorageError),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadAdminStudioPicture({
    required String image,
    required String fileName,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(fileName);
      ref.putString(image, format: PutStringFormat.base64);
      final String downloadUrl = await ref.getDownloadURL();
      return Right<Failure, String>(downloadUrl);
    } on FirebaseException {
      return Left<Failure, String>(
        Failure(
          error: AppError.firebaseStorageError,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadTattooistProfilePicture({
    required String image,
    required String fileName,
  }) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(fileName);
      ref.putString(image, format: PutStringFormat.base64);
      final String downloadUrl = await ref.getDownloadURL();
      return Right<Failure, String>(downloadUrl);
    } on FirebaseException {
      return Left<Failure, String>(
        Failure(
          error: AppError.firebaseStorageError,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      if (await _secureStorage.logout()) {
        await FirebaseAuth.instance.signOut();
        return const Right<Failure, String>('ok');
      } else {
        return Left<Failure, String>(
          Failure(
            error: AppError.serverError,
          ),
        );
      }
    } on FirebaseException {
      return Left<Failure, String>(
        Failure(
          error: AppError.firebaseStorageError,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> getAdminsValidation(
      {required String email}) async {
    try {
      final Query<Map<String, dynamic>> documentReference = _firebaseFirestore
          .collection(SignUpRepositoryImpl.adminsDatabase)
          .where(kEmailData, isEqualTo: email);

      final QuerySnapshot<Map<String, dynamic>> query =
          await documentReference.get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> data = query.docs;

      if (data.isEmpty) {
        return const Right<Failure, String?>(null);
      }
      final String id = data[0].id;
      return Right<Failure, String?>(id);
    } on FirebaseException {
      return Left<Failure, String?>(
        Failure(error: AppError.firebaseStorageError),
      );
    }
  }

  @override
  Future<Either<Failure, Admin?>> getAdminStudio(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentReference =
          await _firebaseFirestore
              .collection(SignUpRepositoryImpl.adminsDatabase)
              .doc(id)
              .get();

      final Admin admin = Admin.fromMap(documentReference.data()!);
      return Right<Failure, Admin?>(admin);
    } on FirebaseException {
      return Left<Failure, Admin?>(
        Failure(error: AppError.firebaseStorageError),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> updateTattoistStudio(Admin admin) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore
              .collection(SignUpRepositoryImpl.tattooistsDatabase)
              .doc(_firebaseAuth.currentUser!.uid);

      await documentReference.get().then(
        (DocumentSnapshot<Map<String, dynamic>> value) {
          if (value.exists) {
            documentReference.update(
              <String, dynamic>{
                kStudioEmailTattoist: admin.email,
                kStudioIdTattoist: admin.id,
                kStudioNameTattoist: admin.placeName,
                kStudioPictureTattoist: admin.placePicture,
              },
            );
          }
        },
      );
      await _updateTattoistStudio(admin: admin);
      return const Right<Failure, bool>(true);
    } on FirebaseException {
      return Left<Failure, bool>(
        Failure(error: AppError.firebaseStorageError),
      );
    }
  }
}
