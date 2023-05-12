import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../firebase_options.dart';
import '../../features/admin_profile/admin_profile_view_model.dart';
import '../../features/admin_sign_up/admin_sign_up_view_model.dart';
import '../../features/create_date/create_date_view_model.dart';
import '../../features/home/home_view_model.dart';
import '../../features/home_admin/detail_ink_date/detail_ink_date_view_model.dart';
import '../../features/home_admin/detail_place/detail_place_view_model.dart';
import '../../features/home_admin/home_admin_view_model.dart';
import '../../features/home_admin/pick_place_admin/pick_place_admin_view_model.dart';
import '../../features/login/login_view_model.dart';
import '../../features/pick_date/pick_date_view_model.dart';
import '../../features/pick_place/pick_place_view_model.dart';
import '../../features/splash/splash_view_model.dart';
import '../../features/tatooist_profile/tattoist_profile_view_model.dart';
import '../../features/tatooist_sign_up/tatooist_sign_up_view_model.dart';
import '../../manager/push_notification_manager.dart';
import '../../model/config.dart';
import '../../model/repository/create_date/create_date_repository_impl.dart';
import '../../model/repository/detail_ink_date/detail_ink_date_repository_impl.dart';
import '../../model/repository/home/home_repository_impl.dart';
import '../../model/repository/home_admin/home_admin_repository_impl.dart';
import '../../model/repository/ink_date/ink_date_repository_impl.dart';
import '../../model/repository/login/login_repository_impl.dart';
import '../../model/repository/pick_date/pick_date_repository_impl.dart';
import '../../model/repository/pick_place/pick_place_repository_impl.dart';
import '../../model/repository/pick_place_admin/pick_place_admin_repository_impl.dart';
import '../../model/repository/profile/profile_repository_impl.dart';
import '../../model/repository/scheduled_notifications/scheduled_notifications_impl.dart';
import '../../model/repository/sign_up/sign_up_repository_impl.dart';
import '../../model/storage/secure_storage.dart';
import '../../model/storage/secure_storage_impl.dart';
import '../../theme/theme_view_model.dart';
import 'flavor.dart';

abstract class Bootstrapper {
  factory Bootstrapper.fromFlavor(Flavor flavor) {
    Bootstrapper result;
    switch (flavor) {
      case Flavor.develop:
        result = _DevelopBootstrapper();
        break;
      case Flavor.stage:
        result = _StageBootstrapper();
        break;
      case Flavor.master:
        result = _MasterBootstrapper();
        break;
    }
    return result;
  }

  PackageInfo get appVersion;

  Stream<bool> get bootstrapStream;

  Config get config;

  Flavor get flavor;

  GlobalKey<NavigatorState> get navigatorKey;

  AdminProfileViewModel get adminProfileViewModel;

  AdminSignUpViewModel get adminSignUpViewModel;

  CreateDateViewModel get createDateViewModel;

  DetailPlaceViewModel get detailPlaceViewModel;

  DetailInkDateViewModel get detailInkDateViewModel;

  HomeViewModel get homeViewModel;

  HomeAdminViewModel get homeAdminViewModel;

  LoginViewModel get loginViewModel;

  SplashViewModel get splashViewModel;

  PickDateViewModel get pickDateViewModel;

  PickPlaceViewModel get pickPlaceViewModel;

  PickPlaceAdminViewModel get pickPlaceAdminViewModel;

  TattooistProfileViewModel get tattooistProfileViewModel;

  TattooistSignUpViewModel get tattooistSignUpViewModel;

  ThemeViewModel get themeViewModel;

  Future<void> bootstrap();

  void dispose();

  bool isInitialized();
}

class _BaseBootstrapper implements Bootstrapper {
  _BaseBootstrapper(Flavor flavor) : _flavor = flavor;

  final StreamController<bool> _bootstrapStreamController =
      StreamController<bool>.broadcast();
  final Flavor _flavor;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late AdminProfileViewModel _adminProfileViewModel;
  late AdminSignUpViewModel _adminSignUpViewModel;
  late PackageInfo _appversion;
  late Config _config;
  late Connectivity _connectivity;
  late CreateDateViewModel _createDateViewModel;
  late DetailPlaceViewModel _detailPlaceViewModel;
  late DetailInkDateViewModel _detailInkDateViewModel;
  late HomeViewModel _homeViewModel;
  late HomeAdminViewModel _homeAdminViewModel;
  late LoginViewModel _loginViewModel;
  late PickDateViewModel _pickDateViewModel;
  late PickPlaceViewModel _pickPlaceViewModel;
  late PickPlaceAdminViewModel _pickPlaceAdminViewModel;
  late SecureStorage _secureStorage;
  late SplashViewModel _splashViewModel;
  late TattooistProfileViewModel _tattooistProfileViewModel;
  late TattooistSignUpViewModel _tattooistSignUpViewModel;
  late ThemeViewModel _themeViewModel;

  bool _initialized = false;

  @override
  Future<void> bootstrap() async {
    if (!_initialized) {
      _appversion = await PackageInfo.fromPlatform();

      final String configJson = await rootBundle.loadString(_flavor.configFile);

      _config = Config.fromMap(json.decode(configJson) as Map<String, dynamic>);

      _connectivity = Connectivity();
      final ConnectivityResult status = await _connectivity.checkConnectivity();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await PushNotificationsManager().init();

      final FirebaseAuth firebaseAuthInstace = FirebaseAuth.instance;

      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      _secureStorage = SecureStorageImpl();

      //* VIEWMODELS BEGIN
      final LoginRepositoryImpl loginRepositoryImpl = LoginRepositoryImpl(
        firebaseFirestore: firebaseFirestore,
        secureStorage: _secureStorage,
      );

      final SignUpRepositoryImpl signupRepository = SignUpRepositoryImpl(
        firebaseAuth: firebaseAuthInstace,
        firebaseFirestore: firebaseFirestore,
      );

      _adminProfileViewModel = AdminProfileViewModel(
        homeRepository: HomeRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        profileRepository: ProfileRepositoryImpl(
          firebaseAuthInstace,
          firebaseFirestore,
          _secureStorage,
        ),
      );

      _adminSignUpViewModel =
          AdminSignUpViewModel(signUpRepository: signupRepository);

      _createDateViewModel = CreateDateViewModel(
        inkDateRepository: InkDateRepositoryImpl(
          secureStorage: _secureStorage,
        ),
        createDateRepository: CreateDateRepositoryImpl(
          firebaseAuth: firebaseAuthInstace,
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
      );

      _homeViewModel = HomeViewModel(
        homeRepository: HomeRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        secureStorage: _secureStorage,
        notificationsRepository: ScheduledNotificationsImpl(_secureStorage),
      );

      _detailPlaceViewModel = DetailPlaceViewModel(
        homeAdminRepository: HomeAdminRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
      );

      _detailInkDateViewModel = DetailInkDateViewModel(
        detailInkDateRepository: DetailInkDateRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        homeAdminRepository: HomeAdminRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
      );

      _homeAdminViewModel = HomeAdminViewModel(
        homeAdminRepository: HomeAdminRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        secureStorage: _secureStorage,
      );

      _loginViewModel = LoginViewModel(
        loginRepository: loginRepositoryImpl,
        secureStorage: _secureStorage,
      );

      _splashViewModel = SplashViewModel();

      _pickDateViewModel = PickDateViewModel(
        inkDateRepository: InkDateRepositoryImpl(
          secureStorage: _secureStorage,
        ),
        pickDateRepository: PickDateRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
      );

      _pickPlaceViewModel = PickPlaceViewModel(
        inkDateRepository: InkDateRepositoryImpl(
          secureStorage: _secureStorage,
        ),
        pickPlaceRepository: PickPlaceRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
      );

      _pickPlaceAdminViewModel = PickPlaceAdminViewModel(
        homeAdminRepository: HomeAdminRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        pickPlaceAdminRepository: PickPlaceAdminRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        secureStorage: _secureStorage,
      );

      _tattooistProfileViewModel = TattooistProfileViewModel(
        homeRepository: HomeRepositoryImpl(
          firebaseFirestore: firebaseFirestore,
          secureStorage: _secureStorage,
        ),
        profileRepository: ProfileRepositoryImpl(
          firebaseAuthInstace,
          firebaseFirestore,
          _secureStorage,
        ),
      );

      _tattooistSignUpViewModel =
          TattooistSignUpViewModel(signUpRepository: signupRepository);

      _themeViewModel = ThemeViewModel(
        secureStorage: _secureStorage,
      );

      _initialized = true;

      _bootstrapStreamController.add(_initialized);
    }
  }

  @override
  PackageInfo get appVersion => _appversion;

  @override
  Stream<bool> get bootstrapStream => _bootstrapStreamController.stream;

  @override
  Config get config => _config;

  @override
  Flavor get flavor => _flavor;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  AdminProfileViewModel get adminProfileViewModel => _adminProfileViewModel;

  @override
  AdminSignUpViewModel get adminSignUpViewModel => _adminSignUpViewModel;

  @override
  CreateDateViewModel get createDateViewModel => _createDateViewModel;

  @override
  DetailPlaceViewModel get detailPlaceViewModel => _detailPlaceViewModel;

  @override
  DetailInkDateViewModel get detailInkDateViewModel => _detailInkDateViewModel;

  @override
  HomeViewModel get homeViewModel => _homeViewModel;

  @override
  HomeAdminViewModel get homeAdminViewModel => _homeAdminViewModel;

  @override
  LoginViewModel get loginViewModel => _loginViewModel;

  @override
  SplashViewModel get splashViewModel => _splashViewModel;

  @override
  PickDateViewModel get pickDateViewModel => _pickDateViewModel;

  @override
  PickPlaceViewModel get pickPlaceViewModel => _pickPlaceViewModel;

  @override
  PickPlaceAdminViewModel get pickPlaceAdminViewModel =>
      _pickPlaceAdminViewModel;

  @override
  TattooistProfileViewModel get tattooistProfileViewModel =>
      _tattooistProfileViewModel;

  @override
  TattooistSignUpViewModel get tattooistSignUpViewModel =>
      _tattooistSignUpViewModel;

  @override
  ThemeViewModel get themeViewModel => _themeViewModel;

  @override
  void dispose() {
    _initialized = false;
    _bootstrapStreamController.add(_initialized);
    _bootstrapStreamController.close();
  }

  @override
  bool isInitialized() => _initialized;
}

class _DevelopBootstrapper extends _BaseBootstrapper {
  _DevelopBootstrapper() : super(Flavor.develop);
}

class _StageBootstrapper extends _BaseBootstrapper {
  _StageBootstrapper() : super(Flavor.stage);
}

class _MasterBootstrapper extends _BaseBootstrapper {
  _MasterBootstrapper() : super(Flavor.master);
}
