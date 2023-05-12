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
import '../../widgets/number_adder.dart';
import '../../widgets/sign_up_background.dart';
import '../../widgets/succesfull_dialog.dart';
import 'admin_sign_up_view_model.dart';

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({
    required this.fcmToken,
    Key? key,
  }) : super(key: key);

  final String? fcmToken;

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  late TextEditingController _checkPasswordController;
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _placeNameController;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => context.read<AdminSignUpViewModel>().init(widget.fcmToken),
    );
    _checkPasswordController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _placeNameController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _checkPasswordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _placeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final NumberAdder numberAdder = NumberAdder();
    return Consumer<AdminSignUpViewModel>(
      builder:
          (BuildContext context, AdminSignUpViewModel value, Widget? child) {
        if (value.state == AdminSignUpViewState.emailAlreadyinUse) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              showInkDateSnackBar(localizations.emailAlreadyInUse),
            ),
          );
        }

        if (value.state == AdminSignUpViewState.dataCompleted) {
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
              context.read<AdminSignUpViewModel>().init(widget.fcmToken);
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
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                textEditingController: _fullNameController,
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
                                textInputAction: TextInputAction.next,
                                textEditingController: _emailController,
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
                                textInputAction: TextInputAction.next,
                                textEditingController: _passwordController,
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
                                textInputAction: TextInputAction.next,
                                textEditingController: _checkPasswordController,
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
                                hintText: localizations.hintPlaceName,
                                keyboardType: TextInputType.name,
                                labelText: localizations.placeName,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                textEditingController: _placeNameController,
                                validator: (String? placeName) {
                                  if (placeName == null || placeName.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.xLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    localizations.places,
                                    style: const TextStyle(fontSize: 22.0),
                                  ),
                                  const SizedBox(width: Spacing.medium),
                                  numberAdder,
                                ],
                              ),
                              const SizedBox(height: Spacing.xLarge),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: InkDateElevatedButton(
                                      isNegative: true,
                                      text: localizations.cancel,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.medium),
                                  Expanded(
                                    child: value.state ==
                                            AdminSignUpViewState.loading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : InkDateElevatedButton(
                                            textColor: AppColors.darkGreen,
                                            text: localizations.confirm,
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                value.createNewAdminUser(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  fullName: _fullNameController
                                                      .text
                                                      .trim(),
                                                  numberOfPlaces: numberAdder
                                                      .currentlyNumber,
                                                  placeName:
                                                      _placeNameController.text
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
