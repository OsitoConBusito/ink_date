import 'package:flutter/cupertino.dart';

class BaseViewModel<T> extends ChangeNotifier {
  String? _description;
  bool _disposed = false;
  T? _state;

  String? get description => _description;

  bool get disposed => _disposed;

  T? get state => _state;

  void initialize(T state) {
    _state = state;
    notifyListeners();
  }

  void setState(
    T state, {
    String? description,
  }) {
    _state = state;
    _description = _description;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
