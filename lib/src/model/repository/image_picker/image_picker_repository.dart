import 'package:dartz/dartz.dart';

import '../../failure.dart';

abstract class ImagePickerRepository {
  Future<Either<Failure, bool>> uploadImage({
    required String image,
    bool isProfilePicture = true,
  });
}
