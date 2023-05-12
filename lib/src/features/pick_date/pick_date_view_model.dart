import 'package:dartz/dartz.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/ink_date/ink_date_repository.dart';
import '../../model/repository/model/custom_dates.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/repository/model/customer.dart';
import '../../model/repository/model/ink_date.dart';
import '../../model/repository/pick_date/pick_date_repository.dart';
import '../../utils/utils.dart';

enum PickDateViewState {
  completed,
  error,
  loading,
}

class PickDateViewModel extends BaseViewModel<PickDateViewState> {
  PickDateViewModel({
    required InkDateRepository inkDateRepository,
    required PickDateRepository pickDateRepository,
  })  : _inkDateRepository = inkDateRepository,
        _pickDateRepository = pickDateRepository;

  final InkDateRepository _inkDateRepository;
  final PickDateRepository _pickDateRepository;

  InkDate? _inkDate;

  List<CustomInkDate>? _inkDatesWhereDay;
  List<CustomInkDate>? _inkDates;

  List<CustomInkDate>? get inkDatesWhereDay => _inkDatesWhereDay;
  List<CustomInkDate>? get inkDates => _inkDates;

  InkDate? get inkDate => _inkDate;

  Future<void> saveInkDateStorage(InkDate inkDate) async {
    setState(PickDateViewState.loading);
    final Either<Failure, String> response =
        await _inkDateRepository.saveInkDate(
      inkDate: inkDate,
    );
    response.fold(
      (Failure failure) {
        setState(
          PickDateViewState.error,
          description: failure.description,
        );
      },
      (String right) {
        setState(PickDateViewState.completed);
      },
    );
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

  List<CustomDates> queryWhereCurrentDay({
    required List<CustomInkDate> inkDates,
    required DateTime time,
  }) {
    final List<CustomInkDate> customInkDates = queryWhereCustomInkDate(
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
      for (int index = 0; index < customDates.length; index++) {
        final CustomDates date = CustomDates(
          date: customDates[index].date,
        );
        for (final CustomInkDate customInkDate in customInkDates) {
          if (customInkDate.startDate.hour == index ||
              customInkDate.endDate.hour == index) {
            date.name = customInkDate.tattooist.fullName;
            date.id = customInkDate.id;
          }
        }
        listCustomDates.add(date);
      }
      return listCustomDates;
    }
  }

  Future<InkDate?> getInkDate() async {
    setState(PickDateViewState.loading);
    final Either<Failure, InkDate?> response =
        await _inkDateRepository.getInkDate();
    response.fold(
      (Failure failure) {
        setState(
          PickDateViewState.error,
          description: failure.description,
        );
      },
      (InkDate? right) {
        _inkDate = right;
        setState(PickDateViewState.completed);
      },
    );
    return _inkDate;
  }

  Future<void> getInkDates() async {
    setState(PickDateViewState.loading);
    final Either<Failure, List<CustomInkDate>?> response =
        await _pickDateRepository.getInkDates();

    response.fold(
      (Failure failure) => setState(PickDateViewState.error),
      (List<CustomInkDate>? inkDates) {
        _inkDates = inkDates;
        if (_inkDates == null) {
          _inkDate = InkDate(
            adminId: '',
            client: Customer(
              email: '',
              fullName: '',
              phoneNumber: '',
              studioId: '',
              tattooistId: '',
            ),
            currentPlace: 0,
            endDate: DateTime.now(),
            moreDetails: '',
            tattooistId: '',
            startDate: DateTime.now(),
            clientId: '',
          );
        }
        setState(PickDateViewState.completed);
      },
    );
  }
}
