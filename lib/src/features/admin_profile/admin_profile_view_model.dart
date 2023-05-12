import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/home/home_repository.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/profile/profile_repository.dart';
import '../../utils/utils.dart';

enum AdminProfileViewState {
  changePasswordCompleted,
  changePasswordLoading,
  completed,
  error,
  imageNotPicked,
  initial,
  loading,
  logout,
}

class AdminProfileViewModel extends BaseViewModel<AdminProfileViewState> {
  AdminProfileViewModel({
    required ProfileRepository profileRepository,
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        _profileRepository = profileRepository;

  final HomeRepository _homeRepository;
  final ProfileRepository _profileRepository;

  Admin? _admin;
  String? _imageUrl;

  Admin? get admin => _admin;
  String? get imageUrl => _imageUrl;

  void init() {
    super.initialize(AdminProfileViewState.initial);
  }

  Future<void> getAdminData() async {
    setState(AdminProfileViewState.loading);
    final Either<Failure, Admin> response =
        await _homeRepository.getAdminData();
    response.fold(
      (Failure failure) {
        setState(AdminProfileViewState.error);
      },
      (Admin newAdmin) {
        _admin = newAdmin;
        _imageUrl = _admin!.profilePicture;
        setState(AdminProfileViewState.completed);
      },
    );
  }

  Future<void> updateAdmintData({
    required int currentPlace,
    required String email,
    required String fullName,
  }) async {
    setState(AdminProfileViewState.loading);
    final Either<Failure, String> responseUpdateData =
        await _profileRepository.updateAdminData(
      email: email,
      name: fullName,
      currentPlace: currentPlace,
    );
    responseUpdateData.fold(
      (Failure failure) {
        setState(
          AdminProfileViewState.error,
        );
      },
      (String data) {
        setState(AdminProfileViewState.completed);
      },
    );
  }

  Future<void> uploadProfilePicture(XFile? photo) async {
    setState(AdminProfileViewState.loading);
    if (photo != null) {
      final Uint8List test = await photo.readAsBytes();
      final String base64image = base64Encode(test);
      final Either<Failure, String> responsefromUpload =
          await _profileRepository.uploadAdminProfilePicture(
        fileName:
            '${Utils.userNameFromEmail(_admin!.email)}_profile_picture.jpg',
        image: base64image,
      );

      responsefromUpload.fold(
        (Failure failure) {
          setState(AdminProfileViewState.error);
        },
        (String downloadUrl) async {
          final Either<Failure, String> updateResponse =
              await _profileRepository.updateAdminProfilePicture(
                  profilePictureUrl: downloadUrl);

          updateResponse.fold(
            (Failure failure) => setState(AdminProfileViewState.error),
            (String imageUrl) {
              _imageUrl = imageUrl;
              setState(AdminProfileViewState.completed);
            },
          );
        },
      );
    } else {
      setState(AdminProfileViewState.imageNotPicked);
    }
  }

  Future<void> uploadStudioPicture(XFile? file) async {
    setState(AdminProfileViewState.loading);
    if (file != null) {
      final Uint8List read = await file.readAsBytes();
      final String base64image = base64Encode(read);
      final Either<Failure, String> reponsePictureStudio =
          await _profileRepository.uploadAdminProfilePicture(
        fileName:
            '${Utils.userNameFromEmail(_admin!.email)}_studio_picture.jpg',
        image: base64image,
      );
      reponsePictureStudio.fold(
        (Failure failure) {
          setState(
            AdminProfileViewState.error,
          );
        },
        (String studioPictureUrl) async {
          final Either<Failure, String> updateResponse =
              await _profileRepository.updateAdminStudioPicture(
            studioPictureUrl: studioPictureUrl,
          );

          updateResponse.fold(
            (Failure failure) => setState(
              AdminProfileViewState.error,
            ),
            (String studioPictureUrl) {
              _imageUrl = studioPictureUrl;
              setState(
                AdminProfileViewState.completed,
              );
            },
          );
        },
      );
    } else {
      setState(AdminProfileViewState.imageNotPicked);
    }
  }

  Future<void> changesPassword({required String email}) async {
    setState(AdminProfileViewState.changePasswordLoading);
    final Either<Failure, bool> response =
        await _profileRepository.sendEmailToChangesPassword(
      email: email,
    );

    response.fold(
      (Failure failure) => setState(
        AdminProfileViewState.error,
        description: failure.description,
      ),
      (bool right) {
        setState(AdminProfileViewState.changePasswordCompleted);
      },
    );
  }

  Future<void> logout() async {
    setState(AdminProfileViewState.loading);
    final Either<Failure, String> response = await _profileRepository.logout();
    response.fold(
      (Failure failure) {
        setState(
          AdminProfileViewState.error,
          description: failure.description,
        );
      },
      (String right) {
        setState(AdminProfileViewState.logout);
      },
    );
  }
}
