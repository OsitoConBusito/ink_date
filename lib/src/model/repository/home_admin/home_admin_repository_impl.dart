import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../core/app/app_error.dart';
import '../../failure.dart';
import '../../storage/secure_storage.dart';
import '../model/admin.dart';
import '../model/custom_ink_date.dart';
import '../model/customer.dart';
import '../model/tattooist.dart';
import 'home_admin_repository.dart';

class HomeAdminRepositoryImpl extends HomeAdminRepository {
  HomeAdminRepositoryImpl({
    required FirebaseFirestore firebaseFirestore,
    required SecureStorage secureStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _secureStorage = secureStorage;

  static const String _kAdminid = 'adminId';
  static const String _kIsCanceled = 'isCanceled';

  static const String customersDatabase = 'customers';
  static const String inkDates = 'inkDates';
  static const String tattooists = 'tattooists';

  final FirebaseFirestore _firebaseFirestore;
  final SecureStorage _secureStorage;

  @override
  Future<Either<Failure, List<CustomInkDate>?>> getInkDates() async {
    final List<CustomInkDate> inkDatesResponse = <CustomInkDate>[];
    final Admin? adminResponse = await _secureStorage.getAdminData();
    if (adminResponse == null) {
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
              .collection(HomeAdminRepositoryImpl.inkDates)
              .where(_kAdminid, isEqualTo: adminResponse.id)
              .where(_kIsCanceled, isEqualTo: false)
              .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> dates =
          documentReference.docs;

      for (final QueryDocumentSnapshot<Map<String, dynamic>> dataInkDate
          in dates) {
        final Map<String, dynamic>? dataCustomers = (await _firebaseFirestore
                .collection(HomeAdminRepositoryImpl.customersDatabase)
                .doc(dataInkDate[_AttributeKeys.clientId].toString())
                .get())
            .data();

        if (dataCustomers == null) {
          return const Right<Failure, List<CustomInkDate>?>(null);
        }

        final Map<String, dynamic>? dataTattoist = (await _firebaseFirestore
                .collection(HomeAdminRepositoryImpl.tattooists)
                .doc(dataInkDate[_AttributeKeys.tattooistId].toString())
                .get())
            .data();

        if (dataTattoist == null) {
          return const Right<Failure, List<CustomInkDate>?>(null);
        }

        inkDatesResponse.add(
          CustomInkDate(
            id: dataInkDate.id,
            adminId: dataInkDate[_AttributeKeys.adminId].toString(),
            customer: Customer.fromMap(dataCustomers),
            currentPlace:
                int.parse(dataInkDate[_AttributeKeys.currentPlace].toString()),
            moreDetails: dataInkDate[_AttributeKeys.moreDetails].toString(),
            endDate:
                DateTime.parse(dataInkDate[_AttributeKeys.endDate].toString()),
            startDate: DateTime.parse(
                dataInkDate[_AttributeKeys.startDate].toString()),
            idTattooist: dataInkDate[_AttributeKeys.tattooistId].toString(),
            tattooist: Tattooist.fromMap(dataTattoist),
          ),
        );
      }

      return Right<Failure, List<CustomInkDate>?>(inkDatesResponse);
    } on FirebaseException catch (error) {
      return Left<Failure, List<CustomInkDate>?>(
        Failure(
          error: AppError.firebaseFirestoreError,
          description: error.code,
        ),
      );
    }
  }
}

abstract class _AttributeKeys {
  static const String adminId = 'adminId';
  static const String moreDetails = 'moreDetails';
  static const String clientId = 'clientId';
  static const String currentPlace = 'currentPlace';
  static const String endDate = 'endDate';
  static const String startDate = 'startDate';
  static const String tattooistId = 'tattooistId';
}
