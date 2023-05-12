import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/spacing.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_text_form_field.dart';
import 'tattoist_profile_view_model.dart';

class ChangesStudioDialog extends StatefulWidget {
  const ChangesStudioDialog({
    Key? key,
    required this.tattooistProfileViewModel,
    required this.width,
  }) : super(key: key);

  final TattooistProfileViewModel tattooistProfileViewModel;
  final double width;

  @override
  State<ChangesStudioDialog> createState() => _ChangesStudioDialogState();
}

class _ChangesStudioDialogState extends State<ChangesStudioDialog> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppColors.backgroundGrey.withOpacity(0.9),
      elevation: 3.0,
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
                      localizations.changesStudio,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: Spacing.large,
                    ),
                    InkDateTextFormField(
                      hintText: localizations.hintEmail,
                      keyboardType: TextInputType.emailAddress,
                      labelText: localizations.email,
                      textEditingController: _emailController,
                      textInputAction: TextInputAction.send,
                    ),
                    InkDateElevatedButton(
                      text: localizations.confirm,
                      textColor: AppColors.darkGreen,
                      onTap: () async {
                        widget.tattooistProfileViewModel.changeStudio(
                          email: _emailController.text.trim(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: Spacing.medium,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: widget.width * 0.28,
                top: -50.0,
                child: CircleAvatar(
                  backgroundColor: AppColors.beige,
                  radius: 50.0,
                  child: SvgPicture.asset(
                    AppImages.logoInkDate,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
