import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../generated/l10n.dart';
import '../theme/app_animations.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import 'ink_date_elevated_button.dart';

class SuccessfullDialog extends StatelessWidget {
  const SuccessfullDialog({
    Key? key,
    required this.message,
    required this.onTap,
    required this.title,
    required this.width,
  }) : super(key: key);

  final String message;
  final VoidCallback onTap;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: AppColors.backgroundGrey,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Wrap(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(
                  Spacing.medium,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: Spacing.xLarge + Spacing.medium,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: Spacing.medium,
                    ),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: Spacing.medium,
                    ),
                    InkDateElevatedButton(
                      text: localizations.confirm,
                      textColor: AppColors.darkGreen,
                      onTap: onTap,
                    ),
                    const SizedBox(
                      height: Spacing.medium,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -50,
                left: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50.0,
                  child: Lottie.asset(AppAnimations.success),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
