import 'package:dartz/dartz.dart';

import '../../../core/mvvm/base_view_model.dart';
import '../../../model/failure.dart';
import '../../../model/repository/detail_ink_date/detail_ink_date_repository.dart';
import '../../../model/repository/home_admin/home_admin_repository.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../model/repository/model/tattooist.dart';
import '../../../utils/utils.dart';

enum DetailInkDateViewState {
  completed,
  completedCancel,
  error,
  initial,
  loading,
}

class DetailInkDateViewModel extends BaseViewModel<DetailInkDateViewState> {
  DetailInkDateViewModel({
    required DetailInkDateRepository detailInkDateRepository,
    required HomeAdminRepository homeAdminRepository,
  })  : _detailInkDateRepository = detailInkDateRepository,
        _homeAdminRepository = homeAdminRepository;

  final DetailInkDateRepository _detailInkDateRepository;

  final HomeAdminRepository _homeAdminRepository;

  List<CustomInkDate>? _inkDates;

  List<CustomInkDate>? get inkDates => _inkDates;

  Future<void> init() async {
    super.initialize(DetailInkDateViewState.initial);
  }

  Future<void> cancelInkDate({
    required String id,
    required String observations,
  }) async {
    setState(DetailInkDateViewState.loading);

    final Either<Failure, bool?> response =
        await _detailInkDateRepository.cancelInkDate(
      id: id,
      observations: observations,
    );

    response.fold(
      (Failure failure) => setState(DetailInkDateViewState.error),
      (bool? right) => setState(DetailInkDateViewState.completedCancel),
    );
  }

  Future<void> getInkDates() async {
    setState(DetailInkDateViewState.loading);

    final Either<Failure, List<CustomInkDate>?> response =
        await _homeAdminRepository.getInkDates();

    response.fold(
      (Failure failure) => setState(DetailInkDateViewState.error),
      (List<CustomInkDate>? inkDates) {
        _inkDates = inkDates;
        setState(DetailInkDateViewState.completed);
      },
    );
  }

  Tattooist getTattooist(List<CustomInkDate> inkDates) {
    return inkDates[0].tattooist;
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

  int queryWhereCustomInkDateLength({
    required List<CustomInkDate> inkDates,
    required DateTime time,
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
}
