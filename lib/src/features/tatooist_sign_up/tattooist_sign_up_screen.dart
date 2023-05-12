import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../theme/app_colors.dart';
import '../../theme/spacing.dart';
import '../../utils/utils.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/ink_date_text_form_field.dart';
import '../../widgets/sign_up_background.dart';
import '../../widgets/succesfull_dialog.dart';
import 'tatooist_sign_up_view_model.dart';

class TattooistSignUpScreen extends StatefulWidget {
  const TattooistSignUpScreen({
    required this.fcmToken,
    Key? key,
  }) : super(key: key);

  final String fcmToken;

  @override
  State<TattooistSignUpScreen> createState() => _TattooistSignUpScreenState();
}

class _TattooistSignUpScreenState extends State<TattooistSignUpScreen> {
  late TextEditingController _checkPasswordController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _studioEmailController;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => context.read<TattooistSignUpViewModel>().init(widget.fcmToken),
    );
    _checkPasswordController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _studioEmailController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _checkPasswordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _studioEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<TattooistSignUpViewModel>(
      builder: (BuildContext context, TattooistSignUpViewModel value,
          Widget? child) {
        if (value.state == TatooistSignUpViewState.emailAlreadyinUse) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.emailAlreadyInUse),
            ),
          );
        }
        if (value.state == TatooistSignUpViewState.studioCodeNotExistError) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.studioEmailNotExist),
            ),
          );
        }
        if (value.state == TatooistSignUpViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              showDialog(
                context: context,
                builder: (BuildContext context) => SuccessfullDialog(
                  message: localizations.succesfullSignUpMessage,
                  onTap: () {
                    value.init(widget.fcmToken);
                    Navigator.of(context)
                        .pushReplacementNamed(NamedRoute.loginScreen);
                  },
                  title: localizations.succesfullSignUp,
                  width: double.infinity,
                ),
              );
              context.read<TattooistSignUpViewModel>().init(widget.fcmToken);
            },
          );
        }
        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Stack(
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
                              const SizedBox(height: Spacing.medium),
                              InkDateTextFormField(
                                hintText: localizations.hintFullName,
                                keyboardType: TextInputType.name,
                                labelText: localizations.fullName,
                                textEditingController: _fullNameController,
                                textInputAction: TextInputAction.next,
                                validator: (String? fullName) {
                                  if (fullName == null || fullName.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.medium),
                              InkDateTextFormField(
                                hintText: localizations.hintEmail,
                                keyboardType: TextInputType.emailAddress,
                                labelText: localizations.email,
                                textEditingController: _emailController,
                                textInputAction: TextInputAction.next,
                                validator: (String? email) {
                                  if (email == null || email.isEmpty) {
                                    return '';
                                  }
                                  if (!Utils.isValidEmail(email)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showInkDateSnackBar(
                                          localizations.notValidEmail),
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.medium),
                              InkDateTextFormField(
                                hintText: localizations.hintPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                labelText: localizations.password,
                                textEditingController: _passwordController,
                                textInputAction: TextInputAction.next,
                                validator: (String? password) {
                                  if (password == null || password.isEmpty) {
                                    return '';
                                  }
                                  if (!Utils.isValidPassword(password)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showInkDateSnackBar(
                                          localizations.passwordConditions),
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.medium),
                              InkDateTextFormField(
                                hintText: localizations.hintPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                labelText: localizations.verifyPassword,
                                textEditingController: _checkPasswordController,
                                textInputAction: TextInputAction.next,
                                validator: (String? password) {
                                  if (password == null || password.isEmpty) {
                                    return '';
                                  }
                                  if (_passwordController.text !=
                                      _checkPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showInkDateSnackBar(
                                          localizations.notMatchPassword),
                                    );
                                    return '';
                                  }
                                  if (!Utils.isValidPassword(password)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showInkDateSnackBar(
                                          localizations.passwordConditions),
                                    );
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.medium),
                              InkDateTextFormField(
                                hintText: localizations.hintStudioEmail,
                                keyboardType: TextInputType.emailAddress,
                                labelText: localizations.studioEmail,
                                textEditingController: _studioEmailController,
                                textInputAction: TextInputAction.next,
                                validator: (String? studioEmail) {
                                  if (studioEmail == null ||
                                      studioEmail.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.xLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: InkDateElevatedButton(
                                      isNegative: true,
                                      text: localizations.cancel,
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.medium),
                                  Expanded(
                                    child: value.state ==
                                            TatooistSignUpViewState.loading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : InkDateElevatedButton(
                                            text: localizations.confirm,
                                            textColor: AppColors.darkGreen,
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                value.createNewTattooistUser(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  studioEmail:
                                                      _studioEmailController
                                                          .text
                                                          .trim(),
                                                  fullName: _fullNameController
                                                      .text
                                                      .trim(),
                                                );
                                              }
                                            },
                                          ),
                                  )
                                ],
                              ),
                              const SizedBox(height: Spacing.xLarge),
                              InkDateElevatedButton(
                                text: localizations.haveAnAccount,
                                textColor: AppColors.darkGreen,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              const SizedBox(height: Spacing.xLarge),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
