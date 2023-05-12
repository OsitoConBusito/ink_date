import 'package:dartz/dartz.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/ink_date/ink_date_repository.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/repository/model/ink_date.dart';
import '../../model/repository/pick_place/pick_place_repository.dart';

enum PickPlaceViewState {
  completed,
  error,
  initial,
  loading,
}

class PickPlaceViewModel extends BaseViewModel<PickPlaceViewState> {
  PickPlaceViewModel({
    required InkDateRepository inkDateRepository,
    required PickPlaceRepository pickPlaceRepository,
  })  : _inkDateRepository = inkDateRepository,
        _pickPlaceRepository = pickPlaceRepository;

  final InkDateRepository _inkDateRepository;
  final PickPlaceRepository _pickPlaceRepository;
  int? _currentPlace;
  InkDate? _inkDate;

  int? get currentPlace => _currentPlace;
  InkDate? get inkDate => _inkDate;

  Future<void> getCurrentPlaces() async {
    setState(PickPlaceViewState.loading);
    final Either<Failure, int?> response =
        await _pickPlaceRepository.getPlaces();
    response.fold(
      (Failure failure) => setState(
        PickPlaceViewState.error,
        description: failure.description,
      ),
      (int? right) {
        _currentPlace = right;
        setState(PickPlaceViewState.completed);
      },
    );
  }

  Future<InkDate?> getInkDate() async {
    setState(PickPlaceViewState.loading);
    final Either<Failure, InkDate?> response =
        await _inkDateRepository.getInkDate();
    response.fold(
      (Failure failure) {
        setState(
          PickPlaceViewState.error,
          description: failure.description,
        );
      },
      (InkDate? right) {
        _inkDate = right;
        setState(PickPlaceViewState.completed);
      },
    );
    return _inkDate;
  }

  bool validateDateInkDate({
    required int currentPlace,
    required DateTime dateTime,
    required List<CustomInkDate> listCustomInkDate,
  }) {
    if (listCustomInkDate.isEmpty) {
      return false;
    }
    final List<CustomInkDate> customInkDates = listCustomInkDate
        .where((CustomInkDate inkDate) => inkDate.currentPlace == currentPlace)
        .toList();
    for (final CustomInkDate customInkDate in customInkDates) {
      if (customInkDate.startDate.isAfter(dateTime) &&
          customInkDate.endDate.isAtSameMomentAs(dateTime)) {
        if (customInkDate.startDate == dateTime) {
          return true;
        }
        return true;
      }
    }
    return false;
  }

  Future<void> saveInkDateStorage(InkDate inkDate) async {
    setState(PickPlaceViewState.loading);
    final Either<Failure, String> response =
        await _inkDateRepository.saveInkDate(
      inkDate: inkDate,
    );
    response.fold(
      (Failure failure) {
        setState(
          PickPlaceViewState.error,
          description: failure.description,
        );
      },
      (String right) {
        setState(PickPlaceViewState.completed);
      },
    );
  }
}
