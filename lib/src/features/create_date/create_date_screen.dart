import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../model/repository/model/customer.dart';
import '../../model/repository/model/ink_date.dart';
import '../../theme/animation_durations.dart';
import '../../theme/app_colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/ink_date_text_form_field.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/sign_up_background.dart';
import '../../widgets/succesfull_dialog.dart';
import 'create_date_view_model.dart';

class CreateDateScreen extends StatefulWidget {
  const CreateDateScreen({Key? key}) : super(key: key);

  @override
  State<CreateDateScreen> createState() => _CreateDateScreenState();
}

class _CreateDateScreenState extends State<CreateDateScreen> {
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _aditionalDetailsController;
  late TextEditingController _clientEmailController;
  late InkDate _inkDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final CreateDateViewModel createDateViewModel =
        context.read<CreateDateViewModel>();
    _aditionalDetailsController = TextEditingController(text: '');
    _clientEmailController = TextEditingController(text: '');
    _clientNameController = TextEditingController(text: '');
    _clientPhoneController = TextEditingController(text: '');

    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await createDateViewModel.getInkDate();
        if (createDateViewModel.inkDate != null) {
          _inkDate = createDateViewModel.inkDate!;
          _aditionalDetailsController =
              TextEditingController(text: _inkDate.moreDetails);
          _clientEmailController =
              TextEditingController(text: _inkDate.client.email);
          _clientNameController = TextEditingController(
            text: _inkDate.client.fullName,
          );
          _clientPhoneController = TextEditingController(
            text: _inkDate.client.phoneNumber,
          );
        } else {
          _aditionalDetailsController = TextEditingController(text: '');
          _clientEmailController = TextEditingController(text: '');
          _clientNameController = TextEditingController(text: '');
          _clientPhoneController = TextEditingController(text: '');
          _inkDate = InkDate(
            adminId: '',
            client: Customer(
              email: '',
              fullName: '',
              phoneNumber: '',
              studioId: '',
              tattooistId: '',
            ),
            currentPlace: 0,
            endDate: DateTime.now(),
            moreDetails: '',
            startDate: DateTime.now(),
            tattooistId: '',
            clientId: '',
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _aditionalDetailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Consumer<CreateDateViewModel>(
      builder:
          (BuildContext context, CreateDateViewModel value, Widget? child) {
        if (value.state == CreateDateViewState.error) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                showInkDateSnackBar(localizations.errorStore),
              );
              _isLoading = false;
            },
          );
        }

        if (value.state == CreateDateViewState.dataCompleted) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
              showDialog(
                context: context,
                builder: (BuildContext context) => SuccessfullDialog(
                  message: localizations.yourAppointment,
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(NamedRoute.homeScreen),
                  title: localizations.succesfullSignUp,
                  width: double.infinity,
                ),
              );
            },
          );
        }

        if (value.state == CreateDateViewState.loadingCollection) {
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
            },
          );
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              localizations.confirmDate,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Stack(
              children: <Widget>[
                SignUpBackground(width: constraints.maxWidth),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(Spacing.medium),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: Spacing.large,
                            ),
                            InkDateTextFormField(
                              hintText: localizations.hintClientName,
                              keyboardType: TextInputType.name,
                              labelText: localizations.clientName,
                              textEditingController: _clientNameController,
                              validator: (String? name) {
                                if (name == null || name.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    showInkDateSnackBar(
                                        localizations.mandatoryField),
                                  );
                                  return '';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateTextFormField(
                              hintText: localizations.hintEmail,
                              keyboardType: TextInputType.emailAddress,
                              labelText: localizations.email,
                              textInputAction: TextInputAction.next,
                              textEditingController: _clientEmailController,
                              validator: (String? email) {
                                if (email == null || email.isEmpty) {
                                  return '';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateTextFormField(
                              hintText: localizations.hintClientPhone,
                              keyboardType: TextInputType.phone,
                              labelText: localizations.clientPhone,
                              textEditingController: _clientPhoneController,
                              textInputAction: TextInputAction.next,
                              validator: (String? clientPhone) {
                                if (clientPhone == null ||
                                    clientPhone.isEmpty) {
                                  return '';
                                }
                                if (clientPhone.length != 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    showInkDateSnackBar(
                                        localizations.notValidPhone),
                                  );
                                  return '';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateElevatedButton(
                              backgroundColor: AppColors.darkGreen,
                              isNegative: true,
                              text: localizations.pickDate,
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();

                                  _inkDate.client = Customer(
                                    email: _clientEmailController.text,
                                    fullName: _clientNameController.text,
                                    phoneNumber: _clientPhoneController.text,
                                    studioId: '',
                                    tattooistId: '',
                                  );
                                  _inkDate.moreDetails =
                                      _aditionalDetailsController.text;
                                  value.saveInkDateStorage(_inkDate);
                                  Navigator.of(context)
                                      .pushNamed(NamedRoute.pickDate);
                                }
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateElevatedButton(
                              backgroundColor: AppColors.darkGreen,
                              isNegative: true,
                              text: localizations.pickHour,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();

                                  _inkDate.client = Customer(
                                    email: _clientEmailController.text,
                                    fullName: _clientNameController.text,
                                    phoneNumber: _clientPhoneController.text,
                                    studioId: '',
                                    tattooistId: '',
                                  );
                                  _inkDate.moreDetails =
                                      _aditionalDetailsController.text;
                                  value.saveInkDateStorage(_inkDate);
                                  final TimeOfDay? startTime =
                                      await showTimePicker(
                                    context: context,
                                    helpText: localizations.startHour,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColors.darkGreen,
                                            background: AppColors.darkGreen,
                                            onBackground: AppColors.darkGreen,
                                            onPrimaryContainer:
                                                AppColors.darkGreen,
                                            primaryContainer:
                                                AppColors.darkGreen,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (startTime == null) {
                                    return;
                                  }
                                  _inkDate.startDate = DateTime(
                                    _inkDate.startDate.year,
                                    _inkDate.startDate.month,
                                    _inkDate.startDate.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );
                                  final TimeOfDay endTime = startTime.replacing(
                                      hour: startTime.hour + 2 >= 24
                                          ? startTime.hour
                                          : startTime.hour + 2);
                                  bool mayor = false;
                                  while (mayor == false) {
                                    await showTimePicker(
                                      context: context,
                                      helpText: localizations.validateDate,
                                      initialTime: endTime,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: AppColors.golden,
                                              background: AppColors.golden,
                                              onBackground: AppColors.golden,
                                              onPrimaryContainer:
                                                  AppColors.golden,
                                              primaryContainer:
                                                  AppColors.golden,
                                              secondaryContainer:
                                                  AppColors.golden,
                                              secondary: AppColors.golden,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (endTime.hour > startTime.hour) {
                                      mayor = true;
                                    }
                                  }
                                  _inkDate.endDate = DateTime(
                                    _inkDate.startDate.year,
                                    _inkDate.startDate.month,
                                    _inkDate.startDate.day,
                                    endTime.hour,
                                    endTime.minute,
                                  );
                                  value.saveInkDateStorage(_inkDate);
                                }
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateElevatedButton(
                              backgroundColor: AppColors.darkGreen,
                              isNegative: true,
                              text: localizations.pickPlace,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  _inkDate.client = Customer(
                                    email: _clientEmailController.text,
                                    fullName: _clientNameController.text,
                                    phoneNumber: _clientPhoneController.text,
                                    studioId: '',
                                    tattooistId: '',
                                  );
                                  _inkDate.moreDetails =
                                      _aditionalDetailsController.text;
                                  Navigator.of(context)
                                      .pushNamed(NamedRoute.pickPlace);
                                }
                              },
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            Text(
                              localizations.moreDetails,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: Spacing.small,
                            ),
                            InkDateTextFormField(
                              height: 150,
                              hintText: '',
                              labelText: '',
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              textEditingController:
                                  _aditionalDetailsController,
                            ),
                            const SizedBox(
                              height: Spacing.medium,
                            ),
                            InkDateElevatedButton(
                              text: localizations.confirmDate,
                              textColor: AppColors.darkGreen,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  if (_inkDate.currentPlace > 0) {
                                    if (_inkDate.endDate.hour >
                                        _inkDate.startDate.hour) {
                                      _inkDate.client = Customer(
                                        email: _clientEmailController.text,
                                        fullName: _clientNameController.text,
                                        phoneNumber:
                                            _clientPhoneController.text,
                                        studioId: '',
                                        tattooistId: '',
                                      );
                                      _inkDate.moreDetails =
                                          _aditionalDetailsController.text;
                                      await value.saveDate(_inkDate);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        showInkDateSnackBar(
                                          localizations.validateHour,
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showInkDateSnackBar(
                                        localizations.validatePickPlace,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
