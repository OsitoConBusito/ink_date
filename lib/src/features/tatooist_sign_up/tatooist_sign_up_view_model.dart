import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../firebase/firebase_error.dart';
import '../../model/failure.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/model/tattooist.dart';
import '../../model/repository/sign_up/sign_up_repository.dart';

enum TatooistSignUpViewState {
  completed,
  emailAlreadyinUse,
  error,
  initial,
  loading,
  studioCodeNotExistError,
}

class TattooistSignUpViewModel extends BaseViewModel<TatooistSignUpViewState> {
  TattooistSignUpViewModel({
    required SignUpRepository signUpRepository,
  }) : _signUpRepository = signUpRepository;

  final SignUpRepository _signUpRepository;

  String? fcmToken;

  void init(String fcmNewToken) {
    fcmToken = fcmNewToken;
    super.initialize(TatooistSignUpViewState.initial);
  }

  Future<void> createNewTattooistUser({
    required String email,
    required String password,
    required String studioEmail,
    required String fullName,
  }) async {
    setState(TatooistSignUpViewState.loading);
    final Either<Failure, Admin> studioEmailExist =
        await _signUpRepository.studioEmailExist(studioEmail);

    studioEmailExist.fold(
      (Failure failure) {
        setState(
          TatooistSignUpViewState.error,
          description: failure.description,
        );
      },
      (Admin studioData) async {
        final Either<Failure, User> signUpResponse =
            await _signUpRepository.signUp(
          email: email,
          password: password,
        );

        signUpResponse.fold(
          (Failure failure) {
            if (failure.description ==
                FirebaseError.emailAlreadyInUse.codeError) {
              setState(
                TatooistSignUpViewState.emailAlreadyinUse,
              );
            } else {
              setState(
                TatooistSignUpViewState.error,
                description: failure.description,
              );
            }
          },
          (User right) async {
            final Either<Failure, bool> saveTattooistDataResponse =
                await _signUpRepository.saveTattooistData(
              Tattooist(
                deviceId: fcmToken!,
                email: email,
                fullName: fullName,
                studioEmail: studioEmail,
                studioId: studioData.id,
                studioPicture: studioData.placePicture,
                studioName: studioData.placeName,
              ),
            );

            saveTattooistDataResponse.fold((Failure failure) {
              if (failure.description ==
                  FirebaseError.emailAlreadyInUse.codeError) {
                setState(
                  TatooistSignUpViewState.emailAlreadyinUse,
                );
              } else {
                setState(
                  TatooistSignUpViewState.error,
                  description: failure.description,
                );
              }
            }, (bool right) => setState(TatooistSignUpViewState.completed));
          },
        );
      },
    );
  }
}
