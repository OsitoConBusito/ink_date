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
import '../../widgets/shake_widget.dart';
import '../../widgets/sign_up_background.dart';
import '../home/home_view_model.dart';
import 'login_view_model.dart';
import 'recover_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ShakeWidgetState> shakeEmailKey =
      GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> shakePasswordKey =
      GlobalKey<ShakeWidgetState>();

  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _passwordController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
    final LoginViewModel loginViewModel = context.read<LoginViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => loginViewModel.init(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final Size size = MediaQuery.of(context).size;

    return Consumer<LoginViewModel>(
      builder: (BuildContext context, LoginViewModel value, Widget? child) {
        if (value.state == LoginViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              context.read<HomeViewModel>().init();
              Navigator.of(context).pushReplacementNamed(NamedRoute.homeScreen);
              context.read<LoginViewModel>().init();
              _isLoading = false;
            },
          );
        }

        if (value.state == LoginViewState.error) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
              context.read<LoginViewModel>().initialize(LoginViewState.initial);
              ScaffoldMessenger.of(context).showSnackBar(
                showInkDateSnackBar(localizations.adminRetrivingdataError),
              );
            },
          );
        }

        if (value.state == LoginViewState.loading) {
          _isLoading = true;
          SchedulerBinding.instance.addPostFrameCallback(
            (_) async {
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
              _isLoading = false;
            },
          );
        }

        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SignUpBackground(width: constraints.maxWidth),
                  Padding(
                    padding: const EdgeInsets.all(Spacing.large),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                const Spacer(),
                                const SizedBox(
                                  height: Spacing.xLarge,
                                ),
                                SvgPicture.asset(
                                  AppImages.inkDateLogoName,
                                  color: AppColors.darkGreen,
                                  width: size.width * 0.4,
                                ),
                                const Spacer(),
                                const SizedBox(
                                  height: Spacing.xLarge,
                                ),
                                ShakeWidget(
                                  key: shakeEmailKey,
                                  shakeOffset: 5.0,
                                  child: InkDateTextFormField(
                                    hintText: localizations.hintEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    icon: Icons.alternate_email,
                                    labelText: localizations.email,
                                    textInputAction: TextInputAction.next,
                                    textEditingController: _emailController,
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
                                ShakeWidget(
                                  key: shakePasswordKey,
                                  shakeOffset: 5.0,
                                  child: InkDateTextFormField(
                                    hintText: localizations.hintPassword,
                                    icon: Icons.lock,
                                    isPassword: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    labelText: localizations.password,
                                    textEditingController: _passwordController,
                                    validator: (String? text) {
                                      if (text == null || text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          showInkDateSnackBar(
                                              localizations.mandatoryField),
                                        );
                                        shakePasswordKey.currentState?.shake();
                                        return '';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: Spacing.medium,
                                ),
                                InkDateElevatedButton(
                                  text: localizations.login,
                                  textColor: AppColors.darkGreen,
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await value.login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                                ),
                                const Spacer(),
                                const SizedBox(
                                  height: Spacing.xLarge,
                                ),
                                InkDateTextButton(
                                  text: localizations.recoverPassword,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          RecoverPasswordDialog(
                                        loginViewModel: value,
                                        width: constraints.maxWidth,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: Spacing.small,
                                ),
                                InkDateTextButton(
                                  isBold: true,
                                  text: localizations.signUp,
                                  onPressed: () =>
                                      Navigator.of(context).pushNamed(
                                    NamedRoute.signUpScreen,
                                    arguments: <String, String?>{
                                      'fcmToken': value.fcmToken
                                    },
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(
                                  height: Spacing.large,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
