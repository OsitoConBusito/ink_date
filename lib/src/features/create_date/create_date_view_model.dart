import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../core/mvvm/base_view_model.dart';
import '../../model/failure.dart';
import '../../model/repository/create_date/create_date_repository.dart';
import '../../model/repository/ink_date/ink_date_repository.dart';
import '../../model/repository/model/ink_date.dart';
import '../../services/notifi_service.dart';

enum CreateDateViewState {
  completed,
  error,
  initial,
  loading,
  loadingCollection,
  dataCompleted,
}

class CreateDateViewModel extends BaseViewModel<CreateDateViewState> {
  CreateDateViewModel({
    required InkDateRepository inkDateRepository,
    required CreateDateRepository createDateRepository,
  })  : _createDateRepository = createDateRepository,
        _inkDateRepository = inkDateRepository;

  final CreateDateRepository _createDateRepository;
  final InkDateRepository _inkDateRepository;

  InkDate? _inkDate;

  InkDate? get inkDate => _inkDate;

  void init() {
    super.initialize(CreateDateViewState.initial);
  }

  Future<void> saveInkDateStorage(InkDate inkDate) async {
    setState(CreateDateViewState.loading);
    final Either<Failure, String> response =
        await _inkDateRepository.saveInkDate(
      inkDate: inkDate,
    );
    response.fold(
      (Failure failure) {
        setState(
          CreateDateViewState.error,
          description: failure.description,
        );
      },
      (String right) {
        setState(CreateDateViewState.completed);
      },
    );
  }

  Future<InkDate?> getInkDate() async {
    setState(CreateDateViewState.loading);
    final Either<Failure, InkDate?> response =
        await _inkDateRepository.getInkDate();
    response.fold(
      (Failure failure) {
        setState(
          CreateDateViewState.error,
          description: failure.description,
        );
      },
      (InkDate? right) {
        _inkDate = right;
        setState(CreateDateViewState.completed);
      },
    );
    return _inkDate;
  }

  Future<void> saveDate(InkDate inkDate) async {
    setState(CreateDateViewState.loadingCollection);

    final Either<Failure, DocumentReference<Map<String, dynamic>>>
        customerResponse = await _createDateRepository.saveCustomer(
      customer: inkDate.client,
    );

    await Future.delayed(const Duration(seconds: 2));

    customerResponse.fold(
      (Failure failure) {
        setState(
          CreateDateViewState.error,
          description: failure.description,
        );
      },
      (DocumentReference<Map<String, dynamic>> right) async {
        inkDate.clientId = right.id;
        final Either<Failure, DocumentReference<Map<String, dynamic>>>
            responseInkDate =
            await _createDateRepository.saveInkDate(inkDate: inkDate);
        responseInkDate.fold(
          (Failure failure) => setState(
            CreateDateViewState.error,
            description: failure.description,
          ),
          (DocumentReference<Map<String, dynamic>> right) async {
            final Either<Failure, bool> responseUpdateTattooist =
                await _createDateRepository
                    .updateTattooistListInkDates(right.id);
            responseUpdateTattooist.fold(
              (Failure failure) => setState(
                CreateDateViewState.error,
                description: failure.description,
              ),
              (bool right) async {
                final Either<Failure, bool> responseDelete =
                    await _createDateRepository.deleteInkDate();
                responseDelete.fold(
                  (Failure failure) => setState(
                    CreateDateViewState.error,
                    description: failure.description,
                  ),
                  (bool right) {
                    setState(CreateDateViewState.dataCompleted);
                    Future<void>.delayed(
                      const Duration(minutes: 1),
                      () {
                        showNotificacion(
                          id: Random().nextInt(1000),
                          title: 'Tienes una cita agendada',
                          body:
                              'Se creado la cita con el cliente ${DateFormat('yyyy-MM-dd hh:mm').format(inkDate.startDate)}',
                        );
                      },
                    );
                    scheduled(
                      id: Random().nextInt(1000),
                      title: 'Tienes una cita agendada',
                      body:
                          'Se creado la cita con el cliente ${DateFormat('yyyy-MM-dd hh:mm').format(inkDate.startDate)}',
                      dateTime:
                          inkDate.startDate.subtract(const Duration(hours: 1)),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
