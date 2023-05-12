import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/noti_scheluder.dart';
import 'scheduled_notifications_repository.dart';

class ScheduledNotificationsImpl extends ScheduledNotificationsRepository {
  ScheduledNotificationsImpl(
    this._secureStorage,
  );
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, bool>> savedInformacionScheduledNotifications(
      NotiScheduled notiScheduled) async {
    try {
      await _secureStorage.savedInfoDay(NotiScheduled.toMap(notiScheduled));
      return const Right<Failure, bool>(true);
    } catch (e) {
      return Left<Failure, bool>(
        Failure(error: AppError.serverError),
      );
    }
  }

  @override
  Future<Either<Failure, NotiScheduled?>> getScheduledNotifications() async {
    try {
      final NotiScheduled? noti = await _secureStorage.getNotiScheduled();
      return Right<Failure, NotiScheduled?>(noti);
    } catch (e) {
      return Left<Failure, NotiScheduled?>(
        Failure(error: AppError.serverError),
      );
    }
  }
}
