import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../firebase/firebase_error.dart';
import '../../model/failure.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/sign_up/sign_up_repository.dart';

enum AdminSignUpViewState {
  completed,
  dataCompleted,
  dataError,
  emailAlreadyinUse,
  error,
  initial,
  loading,
  savingData,
}

class AdminSignUpViewModel extends BaseViewModel<AdminSignUpViewState> {
  AdminSignUpViewModel({
    required SignUpRepository signUpRepository,
  }) : _signUpRepository = signUpRepository;

  final SignUpRepository _signUpRepository;

  String? fcmToken;

  void init(String? fcmNewToken) {
    fcmToken = fcmNewToken;
    setState(AdminSignUpViewState.initial);
  }

  Future<void> createNewAdminUser({
    required String email,
    required String password,
    required String fullName,
    required int numberOfPlaces,
    required String placeName,
  }) async {
    setState(AdminSignUpViewState.loading);

    final Either<Failure, User> response = await _signUpRepository.signUp(
      email: email,
      password: password,
    );

    response.fold(
      (Failure failure) {
        if (failure.description == FirebaseError.emailAlreadyInUse.codeError) {
          setState(
            AdminSignUpViewState.emailAlreadyinUse,
          );
        } else {
          setState(
            AdminSignUpViewState.error,
            description: failure.description,
          );
        }
      },
      (User right) => saveAdminData(
        Admin(
          deviceId: fcmToken!,
          email: email,
          fullName: fullName,
          id: right.uid,
          numberOfPlaces: numberOfPlaces,
          placeName: placeName,
        ),
      ),
    );
  }

  Future<void> saveAdminData(Admin admin) async {
    final Either<Failure, bool> response =
        await _signUpRepository.saveAdminData(admin);

    response.fold(
      (Failure failure) => setState(AdminSignUpViewState.dataError),
      (bool right) => setState(AdminSignUpViewState.dataCompleted),
    );
  }
}
