import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/l10n.dart';
import '../features/image_picker/image_picker_dialog.dart';
import '../theme/app_colors.dart';
import '../theme/icon_size.dart';
import '../theme/spacing.dart';
import 'person_icon.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.constraints,
    this.imageUrl,
    required this.localizations,
    required this.uploadPictures,
  }) : super(key: key);

  final BoxConstraints constraints;
  final String? imageUrl;
  final AppLocalizations localizations;
  final Function(XFile? photo) uploadPictures;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.beige,
      height: constraints.maxHeight * 0.25,
      width: constraints.maxWidth,
      child: InkWell(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) => ImagePickerDialog(
              uploadPictures: uploadPictures,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PersonIcon(
              imageUrl: imageUrl,
              size: imageUrl != null
                  ? IconSize.large * 9.0
                  : IconSize.large - 10.0,
            ),
            const SizedBox(height: Spacing.small),
            Text(
              localizations.uploadProfilePicture,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
