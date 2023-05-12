import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../generated/l10n.dart';
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
import '../../model/config.dart';
import '../../theme/app_themes.dart';
import '../../theme/theme_view_model.dart';
import '../../widgets/splash_widget.dart';
import '../navigation/app_router.dart';
import 'bootstrapper.dart';
import 'flavor.dart';

class App extends StatefulWidget {
  const App({
    required this.bootstrapper,
    Key? key,
  }) : super(key: key);

  final Bootstrapper bootstrapper;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<LocalizationsDelegate<dynamic>> _localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  void initState() {
    super.initState();
    widget.bootstrapper.bootstrap();
  }

  @override
  void dispose() {
    super.dispose();
    widget.bootstrapper.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: widget.bootstrapper.bootstrapStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget result;
        if (snapshot.data ?? true) {
          result = MultiProvider(
            providers: <SingleChildWidget>[
              Provider<PackageInfo>.value(
                  value: widget.bootstrapper.appVersion),
              Provider<Config>.value(value: widget.bootstrapper.config),
              Provider<Flavor>.value(value: widget.bootstrapper.flavor),
              ChangeNotifierProvider<AdminProfileViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.adminProfileViewModel),
              ChangeNotifierProvider<AdminSignUpViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.adminSignUpViewModel),
              ChangeNotifierProvider<CreateDateViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.createDateViewModel,
              ),
              ChangeNotifierProvider<DetailPlaceViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.detailPlaceViewModel,
              ),
              ChangeNotifierProvider<HomeViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.homeViewModel),
              ChangeNotifierProvider<HomeAdminViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.homeAdminViewModel,
              ),
              ChangeNotifierProvider<LoginViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.loginViewModel),
              ChangeNotifierProvider<SplashViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.splashViewModel),
              ChangeNotifierProvider<PickDateViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.pickDateViewModel,
              ),
              ChangeNotifierProvider<PickPlaceViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.pickPlaceViewModel,
              ),
              ChangeNotifierProvider<DetailInkDateViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.detailInkDateViewModel,
              ),
              ChangeNotifierProvider<PickPlaceAdminViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.pickPlaceAdminViewModel,
              ),
              ChangeNotifierProvider<TattooistProfileViewModel>(
                create: (BuildContext context) =>
                    widget.bootstrapper.tattooistProfileViewModel,
              ),
              ChangeNotifierProvider<TattooistSignUpViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.tattooistSignUpViewModel),
              ChangeNotifierProvider<ThemeViewModel>(
                  create: (BuildContext context) =>
                      widget.bootstrapper.themeViewModel),
            ],
            child: Consumer<ThemeViewModel>(
              builder: (_, ThemeViewModel value, __) => MaterialApp(
                theme: AppThemes.lightTheme,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: _localizationsDelegates,
                navigatorKey: widget.bootstrapper.navigatorKey,
                onGenerateRoute: generatedRoutes,
                supportedLocales: AppLocalizations.delegate.supportedLocales,
                title: widget.bootstrapper.flavor.name,
              ),
            ),
          );
        } else {
          result = MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const SplashWidget(),
            localizationsDelegates: _localizationsDelegates,
            supportedLocales: AppLocalizations.delegate.supportedLocales,
          );
        }

        return result;
      },
    );
  }
}
