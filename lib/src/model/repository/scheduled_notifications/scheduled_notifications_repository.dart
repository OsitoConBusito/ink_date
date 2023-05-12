import 'package:dartz/dartz.dart';

import '../../failure.dart';
import '../model/noti_scheluder.dart';

abstract class ScheduledNotificationsRepository {
  Future<Either<Failure, bool>> savedInformacionScheduledNotifications(
      NotiScheduled notiScheduled);

  Future<Either<Failure, NotiScheduled?>> getScheduledNotifications();
}
