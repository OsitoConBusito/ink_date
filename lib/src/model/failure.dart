import '../core/app/app_error.dart';

class Failure {
  Failure({
    this.description,
    required this.error,
  });

  final String? description;
  final AppError error;
}
