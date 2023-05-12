import 'package:dartz/dartz.dart';

import '../../../core/mvvm/base_view_model.dart';
import '../../../model/failure.dart';
import '../../../model/repository/home_admin/home_admin_repository.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../model/repository/pick_place_admin/pick_place_admin_repository.dart';
import '../../../model/storage/secure_storage.dart';
import '../../../utils/utils.dart';

enum PickPlaceAdminViewState {
  completed,
  error,
  initial,
  loading,
}

class PickPlaceAdminViewModel extends BaseViewModel<PickPlaceAdminViewState> {
  PickPlaceAdminViewModel({
    required HomeAdminRepository homeAdminRepository,
    required PickPlaceAdminRepository pickPlaceAdminRepository,
    required SecureStorage secureStorage,
  })  : _homeAdminRepository = homeAdminRepository,
        _secureStorage = secureStorage,
        _pickPlaceAdminRepository = pickPlaceAdminRepository;

  final HomeAdminRepository _homeAdminRepository;
  final PickPlaceAdminRepository _pickPlaceAdminRepository;
  final SecureStorage _secureStorage;

  int? _currentPlace;

  List<CustomInkDate>? _inkDates;

  List<CustomInkDate>? get inkDates => _inkDates;

  int? get currentPlace => _currentPlace;

  Future<void> init() async {
    super.initialize(PickPlaceAdminViewState.initial);
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

  int queryWhereCustomInkDatePlace({
    required List<CustomInkDate> inkDates,
    required int place,
    required DateTime time,
  }) {
    if (inkDates.isEmpty) {
      return 0;
    }

    final int length = inkDates
        .where((CustomInkDate inkDate) =>
            inkDate.currentPlace == place && inkDate.startDate.isSameDate(time))
        .toList()
        .length;
    return length;
  }

  Future<void> getCurrentPlaces() async {
    setState(PickPlaceAdminViewState.loading);
    final Either<Failure, int?> response =
        await _pickPlaceAdminRepository.getPlaces();
    response.fold(
      (Failure failure) => setState(
        PickPlaceAdminViewState.error,
        description: failure.description,
      ),
      (int? right) {
        _currentPlace = right;
        setState(PickPlaceAdminViewState.completed);
      },
    );
  }

  Future<void> getInkDates() async {
    setState(PickPlaceAdminViewState.loading);

    final Either<Failure, List<CustomInkDate>?> response =
        await _homeAdminRepository.getInkDates();

    response.fold(
      (Failure failure) => setState(PickPlaceAdminViewState.error),
      (List<CustomInkDate>? inkDates) {
        _inkDates = inkDates;
        setState(PickPlaceAdminViewState.completed);
      },
    );
  }
}
