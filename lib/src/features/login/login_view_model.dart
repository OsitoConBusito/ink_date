import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/login/login_repository.dart';
import '../../model/storage/secure_storage.dart';

enum LoginViewState {
  completed,
  error,
  forgottenPasswordComplete,
  forgottenPasswordLoading,
  initial,
  loading,
}

class LoginViewModel extends BaseViewModel<LoginViewState> {
  LoginViewModel({
    required LoginRepository loginRepository,
    required SecureStorage secureStorage,
  })  : _loginRepository = loginRepository,
        _secureStorage = secureStorage;

  String? _fcmToken;
  final LoginRepository _loginRepository;
  final SecureStorage _secureStorage;

  String? get fcmToken => _fcmToken;

  Future<void> forgottenPassword({
    required String email,
  }) async {
    setState(LoginViewState.forgottenPasswordLoading);
    final Either<Failure, bool> response =
        await _loginRepository.sendEmailToRecoverPassword(
      email: email,
    );

    response.fold(
      (Failure failure) => setState(
        LoginViewState.error,
        description: failure.description,
      ),
      (bool right) {
        setState(LoginViewState.forgottenPasswordComplete);
      },
    );
  }

  Future<void> init() async {
    super.initialize(LoginViewState.initial);
    _fcmToken = await FirebaseMessaging.instance.getToken();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    setState(LoginViewState.loading);
    final Either<Failure, UserCredential> response =
        await _loginRepository.login(
      email: email,
      password: password,
    );
    await Future.delayed(const Duration(seconds: 3));

    response.fold(
      (Failure failure) => setState(
        LoginViewState.error,
        description: failure.description,
      ),
      (UserCredential userCredential) async {
        final Either<Failure, bool> userResponse =
            await _loginRepository.getUserData(userCredential.user!.email!);

        userResponse.fold(
          (Failure failure) => setState(
            LoginViewState.error,
            description: failure.description,
          ),
          (bool right) => setState(LoginViewState.completed),
        );
      },
    );
  }
}
