import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:intl/intl.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/home/home_repository.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/repository/model/noti_scheluder.dart';
import '../../model/repository/model/tattooist.dart';
import '../../model/repository/scheduled_notifications/scheduled_notifications_repository.dart';
import '../../model/storage/secure_storage.dart';
import '../../services/notifi_service.dart';

enum HomeViewState {
  completed,
  error,
  initial,
  loading,
}

class HomeViewModel extends BaseViewModel<HomeViewState> {
  HomeViewModel(
      {required HomeRepository homeRepository,
      required SecureStorage secureStorage,
      required ScheduledNotificationsRepository notificationsRepository})
      : _homeRepository = homeRepository,
        _secureStorage = secureStorage,
        _notificationsRepository = notificationsRepository;

  final HomeRepository _homeRepository;
  final SecureStorage _secureStorage;
  final ScheduledNotificationsRepository _notificationsRepository;

  Admin? _admin;
  List<CustomInkDate>? _inkDates;
  bool? _isAdminLogged;
  Tattooist? _tattooist;

  Admin? get admin => _admin;
  List<CustomInkDate>? get inkDates => _inkDates;
  bool? get isAdminLogged => _isAdminLogged;
  Tattooist? get tattooist => _tattooist;

  Future<void> init() async {
    super.initialize(HomeViewState.initial);
  }

  Future<void> isAdminLoggedIn() async {
    setState(HomeViewState.loading);
    _isAdminLogged = await _secureStorage.getAdminData() != null;
    setState(HomeViewState.completed);
  }

  Future<void> getInkDates() async {
    setState(HomeViewState.loading);
    if (!_isAdminLogged!) {
      final Either<Failure, List<CustomInkDate>?> response =
          await _homeRepository.getInkDates();

      response.fold(
        (Failure failure) => setState(HomeViewState.error),
        (List<CustomInkDate>? inkDates) async {
          _inkDates = inkDates;

          _inkDates!.sort(
            (CustomInkDate a, CustomInkDate b) =>
                a.startDate.compareTo(b.startDate),
          );

          _inkDates = _inkDates!
              .where(
                (CustomInkDate inkDate) =>
                    DateTime.now().isBefore(inkDate.startDate),
              )
              .toList();

          setState(HomeViewState.completed);
        },
      );
    }
  }

  Future<void> getDataUSer() async {
    setState(HomeViewState.loading);
    if (_isAdminLogged!) {
      _admin = await _secureStorage.getAdminData();
      setState(HomeViewState.completed);
    } else {
      _tattooist = await _secureStorage.getTattooistData();
      setState(HomeViewState.completed);
    }
  }
}
