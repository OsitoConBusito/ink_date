import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';

class ImagePickerDialog extends StatefulWidget {
  const ImagePickerDialog({
    Key? key,
    required this.uploadPictures,
  }) : super(key: key);

  final Function(XFile? photo) uploadPictures;

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppColors.darkGreen,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () async {
                final NavigatorState navigator = Navigator.of(context);
                widget.uploadPictures(
                  await ImagePicker().pickImage(source: ImageSource.camera),
                );
                navigator.pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    localizations.camera,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final NavigatorState navigator = Navigator.of(context);
                widget.uploadPictures(
                  await ImagePicker().pickImage(source: ImageSource.gallery),
                );
                navigator.pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.image_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    localizations.gallery,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
