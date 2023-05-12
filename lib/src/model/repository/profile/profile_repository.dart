import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/admin.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Admin?>> getAdminStudio(String id);

  Future<Either<Failure, String?>> getAdminsValidation({required String email});

  Future<Either<Failure, String>> logout();

  Future<Either<Failure, bool>> sendEmailToChangesPassword({
    required String email,
  });

  Future<Either<Failure, String>> updateAdminData({
    required int currentPlace,
    required String email,
    required String name,
  });

  Future<Either<Failure, String>> updateAdminProfilePicture(
      {required String profilePictureUrl});

  Future<Either<Failure, String>> updateAdminStudioPicture({
    required String studioPictureUrl,
  });

  Future<Either<Failure, String>> updateTattooistProfilePicture({
    required String tattooistPictureUrl,
  });

  Future<Either<Failure, String>> uploadAdminProfilePicture({
    required String image,
    required String fileName,
  });

  Future<Either<Failure, String>> uploadAdminStudioPicture({
    required String image,
    required String fileName,
  });

  Future<Either<Failure, String>> uploadTattooistProfilePicture({
    required String image,
    required String fileName,
  });

  Future<Either<Failure, String>> updateTattooistData({
    required String email,
    required String name,
  });

  Future<Either<Failure, bool>> updateTattoistStudio(Admin admin);
}
