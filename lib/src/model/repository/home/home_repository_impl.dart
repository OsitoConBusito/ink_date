import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import '../model/custom_ink_date.dart';
import '../model/customer.dart';
import '../model/tattooist.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  static const String kAdminId = 'adminId';
  static const String kCustomersDatabase = 'customers';
  static const String kInkDates = 'inkDates';
  static const String kIsCanceled = 'isCanceled';
  static const String kTattooists = 'tattooists';

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, Admin>> getAdminData() async {
    final Admin? adminResponse = await _secureStorage.getAdminData();
    if (adminResponse != null) {
      return Right<Failure, Admin>(adminResponse);
    } else {
      return Left<Failure, Admin>(
        Failure(
          error: AppError.localStorageError,
          description: 'Admin data not found',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomInkDate>?>> getInkDates() async {
    final List<CustomInkDate> inkDatesResponse = <CustomInkDate>[];
    final List<String> inkDates = <String>[];
    final Tattooist? tattooistResponse =
        await _secureStorage.getTattooistData();
    if (tattooistResponse == null) {
      return Left<Failure, List<CustomInkDate>?>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: 'Error',
        ),
      );
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> documentReference =
          await _firebaseFirestore
              .collection(kInkDates)
              .where(kAdminId, isEqualTo: tattooistResponse.studioId)
              .where(kIsCanceled, isEqualTo: false)
              .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> dates =
          documentReference.docs;

      for (final QueryDocumentSnapshot<Map<String, dynamic>> dataInkDate
          in dates) {
        final Map<String, dynamic>? dataCustomers = (await _firebaseFirestore
                .collection(kCustomersDatabase)
                .doc(dataInkDate[_AttributeKeys.clientId].toString())
                .get())
            .data();

        if (dataCustomers == null) {
          return const Right<Failure, List<CustomInkDate>?>(null);
        }

        final Map<String, dynamic>? dataTattoist = (await _firebaseFirestore
                .collection(kTattooists)
                .doc(dataInkDate[_AttributeKeys.tattooistId].toString())
                .get())
            .data();

        if (dataTattoist == null) {
          return const Right<Failure, List<CustomInkDate>?>(null);
        }

        inkDates.add(dataInkDate.id);

        inkDatesResponse.add(
          CustomInkDate(
            adminId: dataInkDate[_AttributeKeys.adminId].toString(),
            currentPlace:
                int.parse(dataInkDate[_AttributeKeys.currentPlace].toString()),
            customer: Customer.fromMap(dataCustomers),
            endDate:
                DateTime.parse(dataInkDate[_AttributeKeys.endDate].toString()),
            id: dataInkDate.id,
            idTattooist: dataInkDate[_AttributeKeys.tattooistId].toString(),
            moreDetails: dataInkDate[_AttributeKeys.moreDetails].toString(),
            startDate: DateTime.parse(
                dataInkDate[_AttributeKeys.startDate].toString()),
            tattooist: Tattooist.fromMap(dataTattoist),
          ),
        );
      }

      _updateInkDatesTattooist(inkDates: inkDates);

      return Right<Failure, List<CustomInkDate>?>(
        inkDatesResponse
            .where((CustomInkDate customInkDate) =>
                customInkDate.tattooist.email == tattooistResponse.email)
            .toList(),
      );
    } on FirebaseException catch (error) {
      return Left<Failure, List<CustomInkDate>?>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }

  Future<void> _updateInkDatesTattooist({
    required List<String> inkDates,
  }) async {
    final Tattooist? tattooistData = await _secureStorage.getTattooistData();
    tattooistData!.datesId = inkDates;
    await _secureStorage.saveUserData(Tattooist.toMap(tattooistData));
  }

  @override
  Future<Either<Failure, Tattooist>> getTattooistData() async {
    final Tattooist? tattooistResponse =
        await _secureStorage.getTattooistData();
    if (tattooistResponse != null) {
      return Right<Failure, Tattooist>(tattooistResponse);
    } else {
      return Left<Failure, Tattooist>(
        Failure(
          error: AppError.localStorageError,
          description: 'Tattooist data not found',
        ),
      );
    }
  }
}

abstract class _AttributeKeys {
  static const String adminId = 'adminId';
  static const String client = 'client';
  static const String clientId = 'clientId';
  static const String currentPlace = 'currentPlace';
  static const String observations = 'observations';
  static const String endDate = 'endDate';
  static const String isCanceled = 'isCanceled';
  static const String moreDetails = 'moreDetails';
  static const String startDate = 'startDate';
  static const String tattooistId = 'tattooistId';
}
