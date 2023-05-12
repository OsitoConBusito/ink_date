import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/home/home_repository.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/model/tattooist.dart';
import '../../model/repository/profile/profile_repository.dart';
import '../../utils/utils.dart';

enum TattooistProfileViewState {
  changePasswordCompleted,
  changePasswordLoading,
  completed,
  completedUpdateStudio,
  error,
  imageNotPicked,
  initial,
  loading,
  logout,
  studioNotFound,
}

class TattooistProfileViewModel
    extends BaseViewModel<TattooistProfileViewState> {
  TattooistProfileViewModel({
    required HomeRepository homeRepository,
    required ProfileRepository profileRepository,
  })  : _homeRepository = homeRepository,
        _profileRepository = profileRepository;

  final HomeRepository _homeRepository;
  final ProfileRepository _profileRepository;

  String? _imageUrl;
  Tattooist? _tattooist;

  String? get imageUrl => _imageUrl;
  Tattooist? get tattooist => _tattooist;

  void init() {
    super.initialize(TattooistProfileViewState.initial);
  }

  Future<void> getTattooistData() async {
    setState(TattooistProfileViewState.loading);
    final Either<Failure, Tattooist> response =
        await _homeRepository.getTattooistData();
    response.fold(
      (Failure failure) {
        setState(TattooistProfileViewState.error);
      },
      (Tattooist newTattooist) {
        _tattooist = newTattooist;
        _imageUrl = _tattooist!.profilePicture;
        setState(TattooistProfileViewState.completed);
      },
    );
  }

  Future<void> changeStudio({required String email}) async {
    setState(TattooistProfileViewState.loading);
    final Either<Failure, String?> response =
        await _profileRepository.getAdminsValidation(email: email);

    response.fold(
      (Failure failure) {
        setState(
          TattooistProfileViewState.error,
        );
      },
      (String? data) async {
        if (data == null) {
          setState(TattooistProfileViewState.studioNotFound);
        } else {
          final Either<Failure, Admin?> responseAdmin =
              await _profileRepository.getAdminStudio(data);

          responseAdmin.fold(
            (Failure failure) {
              setState(TattooistProfileViewState.error);
            },
            (Admin? admin) async {
              final Either<Failure, bool> responseUpdate =
                  await _profileRepository.updateTattoistStudio(admin!);

              responseUpdate.fold(
                (Failure failure) => setState(TattooistProfileViewState.error),
                (bool admin) =>
                    setState(TattooistProfileViewState.completedUpdateStudio),
              );
            },
          );
        }
      },
    );
  }

  Future<void> updateTattooistData({
    required String email,
    required String fullName,
  }) async {
    setState(TattooistProfileViewState.loading);
    final Either<Failure, String> responseUpdateData =
        await _profileRepository.updateTattooistData(
      email: email,
      name: fullName,
    );
    responseUpdateData.fold(
      (Failure failure) {
        setState(
          TattooistProfileViewState.error,
        );
      },
      (String data) {
        setState(TattooistProfileViewState.completed);
      },
    );
  }

  Future<void> uploadProfilePicture(XFile? photo) async {
    setState(TattooistProfileViewState.loading);
    if (photo != null) {
      final Uint8List test = await photo.readAsBytes();
      final String base64image = base64Encode(test);
      final Either<Failure, String> responsefromUpload =
          await _profileRepository.uploadAdminProfilePicture(
        fileName:
            '${Utils.userNameFromEmail(_tattooist!.email)}_profile_picture.jpg',
        image: base64image,
      );

      responsefromUpload.fold(
        (Failure failure) {
          setState(TattooistProfileViewState.error);
        },
        (String downloadUrl) async {
          final Either<Failure, String> updateResponse =
              await _profileRepository.updateTattooistProfilePicture(
            tattooistPictureUrl: downloadUrl,
          );

          updateResponse.fold(
            (Failure failure) {
              setState(
                TattooistProfileViewState.error,
              );
            },
            (String imageUrl) {
              _imageUrl = imageUrl;
              setState(TattooistProfileViewState.completed);
            },
          );
        },
      );
    } else {
      setState(TattooistProfileViewState.imageNotPicked);
    }
  }

  Future<void> changesPassword({required String email}) async {
    setState(TattooistProfileViewState.changePasswordLoading);
    final Either<Failure, bool> response =
        await _profileRepository.sendEmailToChangesPassword(
      email: email,
    );

    response.fold(
      (Failure failure) => setState(
        TattooistProfileViewState.error,
        description: failure.description,
      ),
      (bool right) {
        setState(TattooistProfileViewState.changePasswordCompleted);
      },
    );
  }

  Future<void> logout() async {
    setState(TattooistProfileViewState.loading);
    final Either<Failure, String> response = await _profileRepository.logout();
    response.fold(
      (Failure failure) {
        setState(
          TattooistProfileViewState.error,
          description: failure.description,
        );
      },
      (String right) {
        setState(TattooistProfileViewState.logout);
      },
    );
  }
}
