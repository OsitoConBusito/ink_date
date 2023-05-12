import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../generated/l10n.dart';
import '../theme/app_animations.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    Key? key,
    this.environment,
    this.version,
  }) : super(key: key);

  final String? environment;
  final String? version;

  Widget _buildEnvironmetTag(BuildContext context) {
    final String environmentTag = AppLocalizations.of(context).environment(
      environment ?? '',
      version ?? '',
    );

    return Text(
      environmentTag,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkGreen,
          ),
          Center(
            child: Lottie.asset(AppAnimations.splashAnimation),
          ),
          Positioned(
            bottom: Spacing.large,
            child: _buildEnvironmetTag(context),
          ),
        ],
      ),
    );
  }
}
