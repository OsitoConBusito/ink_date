import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../theme/animation_durations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/spacing.dart';
import '../../utils/utils.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/ink_date_text_button.dart';
import '../../widgets/ink_date_text_form_field.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/shake_widget.dart';
import '../../widgets/sign_up_background.dart';
import '../login/login_view_model.dart';
import 'changes_password_dialog_tattooist.dart';
import 'changes_studio_dialog.dart';
import 'tattoist_profile_view_model.dart';

class TattooistProfileScreen extends StatefulWidget {
  const TattooistProfileScreen({Key? key}) : super(key: key);

  @override
  State<TattooistProfileScreen> createState() => _TattooistProfileScreenState();
}

class _TattooistProfileScreenState extends State<TattooistProfileScreen> {
  final GlobalKey<ShakeWidgetState> shakeEmailKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> shakeFullNameKey =
      GlobalKey<ShakeWidgetState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;

  String? _imageUrl;
  String? _studioEmail;
  String? _studioName;
  String? _studioUrl;
  bool _isLoading = false;

  @override
  void initState() {
    _fullNameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
    final TattooistProfileViewModel tattooistProfileViewModel =
        context.read<TattooistProfileViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        tattooistProfileViewModel.init();
        await tattooistProfileViewModel.getTattooistData();
        _emailController.text = tattooistProfileViewModel.tattooist!.email;
        _fullNameController.text =
            tattooistProfileViewModel.tattooist!.fullName;
        _imageUrl = tattooistProfileViewModel.tattooist!.profilePicture;
        _studioName = tattooistProfileViewModel.tattooist!.studioName;
        _studioEmail = tattooistProfileViewModel.tattooist!.studioEmail;
        _studioUrl = tattooistProfileViewModel.tattooist!.studioPicture;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Consumer<TattooistProfileViewModel>(
      builder: (
        BuildContext context,
        TattooistProfileViewModel value,
        _,
      ) {
        if (value.state == TattooistProfileViewState.error) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.wrongUserOrPassword),
            ),
          );
          return const Scaffold();
        } else if (value.state == TattooistProfileViewState.imageNotPicked) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.imageNotPicked),
            ),
          );
          return const Scaffold();
        } else if (value.state == TattooistProfileViewState.logout) {
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
        } else if (value.state == TattooistProfileViewState.studioNotFound) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar('El estudio no fue encontrado.'),
            );
          });
          return _body(
            localizations: localizations,
            tattooistProfileViewModel: value,
          );
        } else if (value.state == TattooistProfileViewState.loading) {
          _isLoading = true;
          SchedulerBinding.instance.addPostFrameCallback(
            (_) async {
              Navigator.of(context).pop();
              await showGeneralDialog(
                context: context,
                barrierColor: Colors.black12.withOpacity(0.3),
                barrierDismissible: false,
                transitionDuration:
                    const Duration(milliseconds: AnimationDurations.medium),
                pageBuilder: (_, __, ___) => const Expanded(
                  child: LoadingScreen(),
                ),
              );
            },
          );
          return const Scaffold();
        } else if (value.state == TattooistProfileViewState.completed) {
          return _body(
            tattooistProfileViewModel: value,
            localizations: localizations,
          );
        } else if (value.state ==
            TattooistProfileViewState.completedUpdateStudio) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => Navigator.of(context)
                .pushNamed(NamedRoute.tattooistProfileScreen),
          );

          return const Scaffold();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Scaffold _body({
    required TattooistProfileViewModel tattooistProfileViewModel,
    required AppLocalizations localizations,
  }) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkGreen,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              AppImages.tattooMachine,
              color: Colors.white,
            ),
            const SizedBox(width: Spacing.medium),
            Text(
              localizations.tatooist,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: <Widget>[
            SignUpBackground(width: constraints.maxWidth),
            Column(
              children: <Widget>[
                ProfileHeader(
                  constraints: constraints,
                  imageUrl: _imageUrl,
                  localizations: localizations,
                  uploadPictures:
                      tattooistProfileViewModel.uploadProfilePicture,
                ),
                SizedBox(
                  height: constraints.maxHeight - 188.0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Spacing.large),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(
                            height: Spacing.medium,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                if (emailText == null || emailText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    showInkDateSnackBar(
                                        localizations.mandatoryField),
                                  );
                                  shakeEmailKey.currentState?.shake();
                                  return '';
                                }
                                if (!Utils.isValidEmail(emailText)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                    ChangesPasswordDialogTattooist(
                                  loginViewModel: tattooistProfileViewModel,
                                  width: constraints.maxWidth,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: Spacing.medium,
                          ),
                          InkDateTextButton(
                            isBold: true,
                            text: localizations.changePlace,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ChangesStudioDialog(
                                  tattooistProfileViewModel:
                                      tattooistProfileViewModel,
                                  width: constraints.maxWidth,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: Spacing.large,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            minRadius: constraints.maxWidth * 0.15,
                            child: _studioUrl == null
                                ? Text(
                                    localizations.picture.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.golden,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: constraints.maxHeight * 0.2,
                                      imageUrl: _studioUrl!,
                                      placeholder:
                                          (BuildContext context, String url) =>
                                              const CircularProgressIndicator(),
                                      width: constraints.maxWidth * 0.4,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: Spacing.large,
                          ),
                          SizedBox(
                            child: AutoSizeText(
                              _studioEmail!,
                              style: const TextStyle(
                                color: AppColors.darkGreen,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              wrapWords: false,
                            ),
                          ),
                          const SizedBox(
                            height: Spacing.medium,
                          ),
                          Text(
                            _studioName!,
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: Spacing.xLarge,
                          ),
                          InkDateElevatedButton(
                            text: localizations.updateData,
                            onTap: () async {
                              await tattooistProfileViewModel
                                  .updateTattooistData(
                                email: _emailController.text,
                                fullName: _fullNameController.text,
                              );
                            },
                          ),
                          const SizedBox(
                            height: Spacing.medium,
                          ),
                          InkDateTextButton(
                            isBold: true,
                            text: localizations.logout,
                            onPressed: () => tattooistProfileViewModel.logout(),
                          ),
                          const SizedBox(
                            height: Spacing.medium,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
