import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/app/app_error.dart';
import '../../../utils/utils.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import '../model/tattooist.dart';
import 'image_picker_repository.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  ImagePickerRepositoryImpl({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, bool>> uploadImage({
    required String image,
    bool isProfilePicture = true,
  }) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final Admin? adminData = await _secureStorage.getAdminData();
    late Reference profilePictureReference;
    if (adminData == null) {
      final Tattooist? tattooistData = await _secureStorage.getTattooistData();
      final String pathName = Utils.userNameFromEmail(tattooistData!.email)!;
      profilePictureReference = storageRef.child(pathName);
    } else {
      final String pathName = Utils.userNameFromEmail(adminData.email)!;
      profilePictureReference = storageRef.child(pathName);
    }

    try {
      await profilePictureReference.putString(image,
          format: PutStringFormat.base64);
      return const Right<Failure, bool>(true);
    } on FirebaseException catch (error) {
      return Left<Failure, bool>(
        Failure(
          error: AppError.firebaseStorageError,
          description: error.message,
        ),
      );
    }
  }
}
