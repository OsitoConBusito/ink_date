import 'package:dartz/dartz.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/home_admin/home_admin_repository.dart';
import '../../model/repository/model/admin.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/storage/secure_storage.dart';
import '../../utils/utils.dart';

enum HomeAdminViewState {
  completed,
  error,
  initial,
  loading,
}

class HomeAdminViewModel extends BaseViewModel<HomeAdminViewState> {
  HomeAdminViewModel({
    required HomeAdminRepository homeAdminRepository,
    required SecureStorage secureStorage,
  })  : _homeAdminRepository = homeAdminRepository,
        _secureStorage = secureStorage;

  final HomeAdminRepository _homeAdminRepository;
  final SecureStorage _secureStorage;

  Admin? _admin;

  List<CustomInkDate>? _inkDates;

  List<CustomInkDate>? get inkDates => _inkDates;

  Admin? get admin => _admin;

  Future<void> init() async {
    super.initialize(HomeAdminViewState.initial);
  }

  Future<void> getDataUSer() async {
    setState(HomeAdminViewState.loading);

    _admin = await _secureStorage.getAdminData();
    setState(HomeAdminViewState.completed);
  }

  int queryWhereCustomInkDateLength({
    required DateTime time,
    required List<CustomInkDate> inkDates,
  }) {
    if (inkDates.isEmpty) {
      return 0;
    }

    final int length = inkDates
        .where((CustomInkDate inkDate) => inkDate.startDate.isSameDate(time))
        .toList()
        .length;
    return length;
  }

  List<CustomInkDate> queryWhereCustomInkDate({
    required List<CustomInkDate> inkDates,
    required DateTime time,
  }) {
    if (inkDates.isEmpty) {
      return <CustomInkDate>[];
    }

    return inkDates
        .where((CustomInkDate inkDate) => inkDate.startDate.isSameDate(time))
        .toList();
  }

  Future<void> getInkDates() async {
    setState(HomeAdminViewState.loading);

    final Either<Failure, List<CustomInkDate>?> response =
        await _homeAdminRepository.getInkDates();

    response.fold(
      (Failure failure) => setState(HomeAdminViewState.error),
      (List<CustomInkDate>? inkDates) {
        _inkDates = inkDates;
        setState(HomeAdminViewState.completed);
      },
    );
  }
}
