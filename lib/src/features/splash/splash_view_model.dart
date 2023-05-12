import '../../core/mvvm/base_view_model.dart';

enum SplashViewState {
  completed,
  error,
  loading,
}

class SplashViewModel extends BaseViewModel<SplashViewState> {}
