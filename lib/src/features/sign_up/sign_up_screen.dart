import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/spacing.dart';
import '../admin_sign_up/admin_sign_up_screen.dart';
import '../tatooist_sign_up/tattooist_sign_up_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    required this.fcmToken,
    Key? key,
  }) : super(key: key);

  final String fcmToken;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context);
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.darkGreen,
            bottom: TabBar(
              indicatorColor: AppColors.beige,
              indicatorWeight: 8.0,
              tabs: <Widget>[
                _InkDateTab(
                  iconPath: AppImages.tattooMachine,
                  text: localization.tatooist,
                ),
                _InkDateTab(
                  iconPath: AppImages.adminIcon,
                  text: localization.admin,
                ),
              ],
            ),
            toolbarHeight: kToolbarHeight * 0.5,
          ),
          body: TabBarView(
            children: <Widget>[
              TattooistSignUpScreen(
                fcmToken: fcmToken,
              ),
              AdminSignUpScreen(
                fcmToken: fcmToken,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InkDateTab extends StatelessWidget {
  const _InkDateTab({
    Key? key,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  final String text;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.small),
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              color: Colors.white,
            ),
            const SizedBox(width: Spacing.small),
            Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
