import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/spacing.dart';
import '../../utils/utils.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/ink_date_text_button.dart';
import '../../widgets/ink_date_text_form_field.dart';
import '../../widgets/number_adder.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/shake_widget.dart';
import '../../widgets/sign_up_background.dart';
import '../image_picker/image_picker_dialog.dart';
import '../login/login_view_model.dart';
import 'admin_profile_view_model.dart';
import 'changes_password_admin_dialog.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final GlobalKey<ShakeWidgetState> shakeEmailKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> shakeFullNameKey =
      GlobalKey<ShakeWidgetState>();

  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _fullNameController;
  String? _imageUrl;
  final NumberAdder numberAdder = NumberAdder();

  @override
  void initState() {
    _emailController = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController(text: '');
    final AdminProfileViewModel adminProfileViewModel =
        context.read<AdminProfileViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        adminProfileViewModel.init();
        await adminProfileViewModel.getAdminData();
        _emailController.text = adminProfileViewModel.admin!.email;
        _fullNameController.text = adminProfileViewModel.admin!.fullName;
        _imageUrl = adminProfileViewModel.imageUrl;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Consumer<AdminProfileViewModel>(
      builder: (
        BuildContext context,
        AdminProfileViewModel value,
        Widget? child,
      ) {
        if (value.state == AdminProfileViewState.error) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.wrongUserOrPassword),
            ),
          );
          return const Scaffold();
        } else if (value.state == AdminProfileViewState.imageNotPicked) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.imageNotPicked),
            ),
          );
          return const Scaffold();
        }
        if (value.state == AdminProfileViewState.logout) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              context.read<LoginViewModel>().init();
              Navigator.of(context).pushNamedAndRemoveUntil(
                NamedRoute.loginScreen,
                ModalRoute.withName(NamedRoute.loginScreen),
              );
            },
          );
          return const Scaffold();
        } else if (value.state == AdminProfileViewState.completed) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.darkGreen,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    AppImages.adminIcon,
                    color: Colors.white,
                  ),
                  const SizedBox(width: Spacing.medium),
                  Text(
                    localizations.admin,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints constraints,
              ) =>
                  Stack(
                children: <Widget>[
                  SignUpBackground(width: constraints.maxWidth),
                  Column(
                    children: <Widget>[
                      ProfileHeader(
                        constraints: constraints,
                        imageUrl: value.imageUrl,
                        localizations: localizations,
                        uploadPictures: value.uploadProfilePicture,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(Spacing.large),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: Spacing.xSmall,
                                ),
                                ShakeWidget(
                                  key: shakeFullNameKey,
                                  shakeOffset: 5.0,
                                  child: InkDateTextFormField(
                                    hintText: localizations.hintFullName,
                                    keyboardType: TextInputType.name,
                                    labelText: localizations.fullName,
                                    textEditingController: _fullNameController,
                                    textInputAction: TextInputAction.next,
                                    validator: (String? fullNameText) {
                                      if (fullNameText == null ||
                                          fullNameText.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          showInkDateSnackBar(
                                              localizations.mandatoryField),
                                        );
                                        shakeFullNameKey.currentState?.shake();
                                        return '';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: Spacing.medium,
                                ),
                                ShakeWidget(
                                  key: shakeEmailKey,
                                  shakeOffset: 5.0,
                                  child: InkDateTextFormField(
                                    hintText: localizations.hintEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    labelText: localizations.email,
                                    textEditingController: _emailController,
                                    textInputAction: TextInputAction.next,
                                    validator: (String? emailText) {
                                      if (emailText == null ||
                                          emailText.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          showInkDateSnackBar(
                                              localizations.mandatoryField),
                                        );
                                        shakeEmailKey.currentState?.shake();
                                        return '';
                                      }
                                      if (!Utils.isValidEmail(emailText)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          showInkDateSnackBar(
                                              localizations.notValidEmail),
                                        );
                                        shakeEmailKey.currentState?.shake();
                                        return '';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: Spacing.medium,
                                ),
                                InkDateTextButton(
                                  isBold: true,
                                  text: localizations.changePassword,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ChangesPasswordAdminDialog(
                                        adminViewmodel: value,
                                        width: constraints.maxWidth,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Spacing.xLarge,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ImagePickerDialog(
                                              uploadPictures:
                                                  value.uploadStudioPicture,
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          if (value.admin!.placePicture != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                height: 120.0,
                                                imageUrl:
                                                    value.admin!.placePicture!,
                                                placeholder: (
                                                  BuildContext context,
                                                  String url,
                                                ) =>
                                                    const CircularProgressIndicator(),
                                                width: 120.0,
                                              ),
                                            )
                                          else
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              minRadius:
                                                  constraints.maxWidth * 0.15,
                                              child: Text(
                                                localizations.picture
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.golden,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          const SizedBox(
                                            height: Spacing.medium,
                                          ),
                                          Text(
                                            localizations.uploadPicture,
                                            style: const TextStyle(
                                              color: AppColors.darkGreen,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Spacing.large,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: Spacing.small,
                                        ),
                                        Text(
                                          value.admin!.placeName,
                                          style: const TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Spacing.medium,
                                        ),
                                        Text(
                                          localizations.changePlacesQuantity,
                                          style: const TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Spacing.small,
                                        ),
                                        numberAdder,
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: Spacing.large,
                                ),
                                InkDateElevatedButton(
                                  text: localizations.updateData,
                                  textColor: AppColors.darkGreen,
                                  onTap: () async {
                                    await value.updateAdmintData(
                                      currentPlace: numberAdder.currentlyNumber,
                                      email: _emailController.text,
                                      fullName: _fullNameController.text,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Spacing.large,
                                ),
                                InkDateTextButton(
                                  isBold: true,
                                  text: localizations.logout,
                                  onPressed: () => value.logout(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            resizeToAvoidBottomInset: false,
          );
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
