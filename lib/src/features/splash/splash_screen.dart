import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../core/app/flavor.dart';
import '../../core/navigation/named_route.dart';
import '../../firebase/firebase_authentication.dart';
import '../../theme/animation_durations.dart';
import '../../widgets/splash_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String _environment;
  late String _version;

  @override
  void initState() {
    super.initState();
    _environment = context.read<Flavor>().name;
    _version = context.read<PackageInfo>().version;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuthetication().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => Future<dynamic>.delayed(
            const Duration(
              milliseconds: AnimationDurations.xLong + AnimationDurations.long,
            ),
            () {
              if (snapshot.hasData) {
                return Navigator.of(context)
                    .pushReplacementNamed(NamedRoute.homeScreen);
              } else {
                return Navigator.of(context)
                    .pushReplacementNamed(NamedRoute.loginScreen);
              }
            },
          ),
        );
        return SplashWidget(
          environment: _environment,
          version: _version,
        );
      },
    );
  }
}
