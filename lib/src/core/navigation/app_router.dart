import 'package:flutter/material.dart';

import '../../features/admin_profile/admin_profile_screen.dart';
import '../../features/create_date/create_date_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home_admin/detail_ink_date/detail_ink_date_screen.dart';
import '../../features/home_admin/detail_place/detail_place_screen.dart';
import '../../features/home_admin/home_admin_screen.dart';
import '../../features/home_admin/pick_place_admin/pick_place_admin.dart';
import '../../features/login/login_screen.dart';
import '../../features/pick_date/pick_date_screen.dart';
import '../../features/pick_place/pick_place_screen.dart';
import '../../features/sign_up/sign_up_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tatooist_profile/tatooist_profile_screen.dart';
import '../../model/repository/model/custom_ink_date.dart';
import 'fade_route_builder.dart';
import 'named_route.dart';
import 'slide_page_route.dart';

RouteFactory get generatedRoutes => (RouteSettings routeSettings) {
      ModalRoute<dynamic>? route;
      final Map<String, dynamic>? argumentsMap =
          routeSettings.arguments as Map<String, dynamic>?;
      Slide slide = Slide.left;

      switch (routeSettings.name) {
        case NamedRoute.adminProfileScreen:
          slide = Slide.right;
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: const AdminProfileScreen(),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.createDate:
          route = FadeRouteBuilder<dynamic>(
            page: const CreateDateScreen(),
          );
          break;
        case NamedRoute.detailInkDateScreen:
          route = FadeRouteBuilder<dynamic>(
            page: DetailInkDateScreen(
              currentPlace: int.parse(argumentsMap!['currentPlace'].toString()),
              customInkDates:
                  argumentsMap['customInkDates'] as List<CustomInkDate>,
              dateTime: DateTime.parse(argumentsMap['time'].toString()),
              id: argumentsMap['id'].toString(),
            ),
          );
          break;
        case NamedRoute.detailPlaceScreen:
          route = FadeRouteBuilder<dynamic>(
            page: DetailPlaceScreen(
              currentPlace: int.parse(argumentsMap!['currentPlace'].toString()),
              time: DateTime.parse(argumentsMap['time'].toString()),
            ),
          );
          break;
        case NamedRoute.homeScreen:
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: const HomeScreen(),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.homeAdminScreen:
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: const HomeAdminScreen(),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.loginScreen:
          route = MaterialPageRoute<dynamic>(
            builder: (_) => const LoginScreen(),
            settings: RouteSettings(name: routeSettings.name),
          );
          break;
        case NamedRoute.pickDate:
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: const PickDateScreen(),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.pickPlace:
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: PickPlaceScreen(
              listCustomInkDates:
                  argumentsMap!['customInkDates'] as List<CustomInkDate>,
            ),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.pickPlaceAdminScreen:
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: PickPlaceAdmin(
                time: DateTime.parse(argumentsMap!['time'].toString())),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.signUpScreen:
          slide = Slide.bottom;
          route = SlidePageRoute(
            offset: slide.slideSide,
            page: SignUpScreen(
              fcmToken: argumentsMap!['fcmToken'].toString(),
            ),
            routeName: routeSettings.name,
          );
          break;
        case NamedRoute.splashScreen:
          route = MaterialPageRoute<dynamic>(
            builder: (_) => const SplashScreen(),
            settings: RouteSettings(
              name: routeSettings.name,
            ),
          );
          break;
        case NamedRoute.tattooistProfileScreen:
          route = MaterialPageRoute<dynamic>(
            builder: (_) => const TattooistProfileScreen(),
            settings: RouteSettings(
              name: routeSettings.name,
            ),
          );
          break;
        default:
          route = MaterialPageRoute<dynamic>(
            builder: (_) => const SplashScreen(),
            settings: RouteSettings(
              name: routeSettings.name,
            ),
          );
          break;
      }
      return route;
    };
