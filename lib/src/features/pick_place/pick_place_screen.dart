import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/repository/model/customer.dart';
import '../../model/repository/model/ink_date.dart';
import '../../theme/animation_durations.dart';
import '../../theme/app_colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/sign_up_background.dart';
import '../create_date/create_date_view_model.dart';
import 'pick_place_view_model.dart';

class PickPlaceScreen extends StatefulWidget {
  const PickPlaceScreen({
    Key? key,
    required this.listCustomInkDates,
  }) : super(key: key);

  final List<CustomInkDate> listCustomInkDates;

  @override
  State<PickPlaceScreen> createState() => _PickPlaceScreenState();
}

class _PickPlaceScreenState extends State<PickPlaceScreen> {
  int? currentPlace;
  InkDate? _inkDate;
  bool _isLoading = false;
  List<bool>? selections;

  @override
  void initState() {
    super.initState();
    final PickPlaceViewModel pickPlaceViewModel =
        context.read<PickPlaceViewModel>();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await pickPlaceViewModel.getInkDate();
        if (pickPlaceViewModel.inkDate != null) {
          _inkDate = pickPlaceViewModel.inkDate;
          await pickPlaceViewModel.getCurrentPlaces();
          if (pickPlaceViewModel.currentPlace != null) {
            currentPlace = pickPlaceViewModel.currentPlace;
          } else {
            currentPlace = 0;
          }
          selections = List<bool>.generate(
            currentPlace!,
            (int index) {
              if (_inkDate!.currentPlace > 0) {
                if (index == _inkDate!.currentPlace) {
                  return true;
                }
              } else {
                return false;
              }
              return false;
            },
          );
        } else {
          await pickPlaceViewModel.getCurrentPlaces();
          if (pickPlaceViewModel.currentPlace != null) {
            currentPlace = pickPlaceViewModel.currentPlace;
          } else {
            currentPlace = 0;
          }
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
          selections = List<bool>.generate(currentPlace!, (int index) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickPlaceViewModel>(
      builder: (BuildContext context, PickPlaceViewModel value, Widget? child) {
        if (value.state == PickPlaceViewState.loading) {
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
          return const Scaffold();
        } else if (value.state == PickPlaceViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
            },
          );
          return _Body(
            customInkDates: widget.listCustomInkDates,
            dateTimeRange: DateTimeRange(
              start: value.inkDate!.startDate,
              end: value.inkDate!.endDate,
            ),
            inkDate: _inkDate!,
            selections: selections!,
            value: value,
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

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.customInkDates,
    required this.dateTimeRange,
    required this.inkDate,
    required this.selections,
    required this.value,
  }) : super(key: key);

  final List<CustomInkDate> customInkDates;
  final DateTimeRange dateTimeRange;
  final InkDate inkDate;
  final List<bool> selections;
  final PickPlaceViewModel value;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkGreen,
        centerTitle: true,
        title: Text(
          localizations.pickPlace,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: <Widget>[
            SignUpBackground(width: constraints.maxWidth),
            Padding(
              padding: const EdgeInsets.all(
                Spacing.medium,
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: Spacing.xLarge,
                  ),
                  InkDateElevatedButton(
                    text: _buildDate(),
                    textColor: AppColors.darkGreen,
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: Spacing.medium,
                  ),
                  Expanded(
                    child: _AvaliableToggleButtons(
                      inkDate: widget.inkDate,
                      listCustomInkDates: widget.customInkDates,
                      localizations: localizations,
                      pickPlaceViewModel: widget.value,
                      selections: widget.selections,
                      width: constraints.maxWidth,
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.medium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const SizedBox(
                        width: Spacing.large,
                      ),
                      Expanded(
                        child: InkDateElevatedButton(
                          isNegative: true,
                          text: localizations.cancel,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: Spacing.xLarge,
                      ),
                      Expanded(
                        child: InkDateElevatedButton(
                          text: localizations.confirm,
                          textColor: AppColors.darkGreen,
                          onTap: () {
                            if (widget.inkDate.currentPlace > 0) {
                              context.read<CreateDateViewModel>().init();
                              Navigator.of(context)
                                  .pushNamed(NamedRoute.createDate);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                showInkDateSnackBar(
                                    localizations.validatePickPlace),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: Spacing.large,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Spacing.medium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildDate() {
    return toBeginningOfSentenceCase(DateFormat('EEEE d MMM / h a - ', 'es')
            .format(widget.dateTimeRange.start))! +
        DateFormat('h a').format(widget.dateTimeRange.end);
  }
}

class _AvaliableToggleButtons extends StatefulWidget {
  const _AvaliableToggleButtons({
    Key? key,
    required InkDate inkDate,
    required List<CustomInkDate> listCustomInkDates,
    required AppLocalizations localizations,
    required PickPlaceViewModel pickPlaceViewModel,
    required List<bool> selections,
    required double width,
  })  : _inkDate = inkDate,
        _listCustomInkDates = listCustomInkDates,
        _localizations = localizations,
        _pickPlaceViewModel = pickPlaceViewModel,
        _selections = selections,
        _width = width,
        super(key: key);

  final InkDate _inkDate;
  final List<CustomInkDate> _listCustomInkDates;
  final AppLocalizations _localizations;
  final PickPlaceViewModel _pickPlaceViewModel;
  final List<bool> _selections;
  final double _width;
  @override
  State<_AvaliableToggleButtons> createState() =>
      _AvaliableToggleButtonsState();
}

class _AvaliableToggleButtonsState extends State<_AvaliableToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget._selections.length,
      padding: const EdgeInsets.only(
        bottom: Spacing.medium,
      ),
      itemBuilder: (_, int index) => InkWell(
          onTap: () {
            if (widget._pickPlaceViewModel.validateDateInkDate(
              currentPlace: index + 1,
              dateTime: widget._inkDate.startDate,
              listCustomInkDate: widget._listCustomInkDates,
            )) {
              ScaffoldMessenger.of(context).showSnackBar(
                showInkDateSnackBar(widget._localizations.spaceIsOccupied),
              );
            } else {
              for (int custom = 0;
                  custom < widget._selections.length;
                  custom++) {
                if (custom == index) {
                  setState(
                    () =>
                        widget._selections[index] = !widget._selections[index],
                  );
                  if (widget._selections[index]) {
                    widget._inkDate.currentPlace = index + 1;
                    widget._pickPlaceViewModel
                        .saveInkDateStorage(widget._inkDate);
                  } else {
                    widget._inkDate.currentPlace = 0;
                    widget._pickPlaceViewModel
                        .saveInkDateStorage(widget._inkDate);
                  }
                } else {
                  setState(
                    () => widget._selections[custom] = false,
                  );
                }
              }
            }
          },
          child: Column(
            children: <Widget>[
              if (index == 0)
                const SizedBox(
                  height: Spacing.medium,
                )
              else
                const SizedBox(),
              SizedBox(
                width: widget._width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.medium,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Espacio ${index + 1}',
                        style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: Spacing.large,
                      ),
                      _AvaliableContainer(
                        active: widget._selections[index],
                        disable: widget._pickPlaceViewModel.validateDateInkDate(
                          currentPlace: index + 1,
                          dateTime: widget._inkDate.startDate,
                          listCustomInkDate: widget._listCustomInkDates,
                        ),
                        localizations: widget._localizations,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
            ],
          )),
    );
  }
}

class _AvaliableContainer extends StatelessWidget {
  const _AvaliableContainer({
    required this.active,
    required this.disable,
    Key? key,
    required AppLocalizations localizations,
  })  : _localizations = localizations,
        super(key: key);

  final AppLocalizations _localizations;
  final bool disable;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disable
              ? Colors.grey
              : active
                  ? AppColors.beige
                  : null,
          border: Border.all(
            color: AppColors.darkGreen,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(
          Spacing.small * 0.5,
        ),
        child: Text(
          _localizations.avaliable,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
