import 'package:dartz/dartz.dart';

import '../../../core/mvvm/base_view_model.dart';
import '../../../model/failure.dart';
import '../../../model/repository/home_admin/home_admin_repository.dart';
import '../../../model/repository/model/custom_dates.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../utils/utils.dart';

enum DetailPlaceViewState {
  completed,
  error,
  initial,
  loading,
}

class DetailPlaceViewModel extends BaseViewModel<DetailPlaceViewState> {
  DetailPlaceViewModel({
    required HomeAdminRepository homeAdminRepository,
  }) : _homeAdminRepository = homeAdminRepository;

  final HomeAdminRepository _homeAdminRepository;

  List<CustomInkDate>? _inkDates;

  List<CustomInkDate>? get inkDates => _inkDates;

  Future<void> init() async {
    super.initialize(DetailPlaceViewState.initial);
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

  List<CustomInkDate> queryWhereCustomInkDate({
    required int currentPlace,
    required List<CustomInkDate> inkDates,
    required DateTime time,
  }) {
    if (inkDates.isEmpty) {
      return <CustomInkDate>[];
    }

    return inkDates
        .where((CustomInkDate inkDate) =>
            inkDate.startDate.isSameDate(time) &&
            inkDate.currentPlace == currentPlace)
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

  List<CustomInkDate> queryWhereTattooist({
    required List<CustomInkDate> inkDates,
    required int place,
    required String tattooistid,
    required DateTime time,
  }) {
    if (inkDates.isEmpty) {
      return <CustomInkDate>[];
    }

    return inkDates
        .where((CustomInkDate inkDate) =>
            inkDate.startDate.isSameDate(time) &&
            inkDate.currentPlace == place &&
            inkDate.idTattooist == tattooistid)
        .toList();
  }

  List<CustomDates> queryWhereCurrentDay({
    required int currentPlace,
    required List<CustomInkDate> inkDates,
    required DateTime time,
  }) {
    final List<CustomInkDate> customInkDates = queryWhereCustomInkDate(
      currentPlace: currentPlace,
      inkDates: inkDates,
      time: time,
    );

    final List<CustomDates> customDates = List<CustomDates>.generate(
      24,
      (int date) {
        return CustomDates(
          date: Utils.dateToString(date),
        );
      },
    );

    if (customInkDates.isEmpty) {
      return customDates;
    } else {
      final List<CustomDates> listCustomDates = <CustomDates>[];
      for (int i = 0; i < customDates.length; i++) {
        final CustomDates date = CustomDates(
          date: customDates[i].date,
        );
        for (final CustomInkDate customInkDate in customInkDates) {
          if (customInkDate.startDate.hour == i) {
            date.name = customInkDate.tattooist.fullName;
            date.id = customInkDate.id;
            date.tattooistId = customInkDate.idTattooist;
          }
        }
        listCustomDates.add(date);
      }
      return listCustomDates;
    }
  }

  Future<void> getInkDates() async {
    setState(DetailPlaceViewState.loading);

    final Either<Failure, List<CustomInkDate>?> response =
        await _homeAdminRepository.getInkDates();

    response.fold(
      (Failure failure) => setState(DetailPlaceViewState.error),
      (List<CustomInkDate>? inkDates) {
        _inkDates = inkDates;
        setState(DetailPlaceViewState.completed);
      },
    );
  }
}
