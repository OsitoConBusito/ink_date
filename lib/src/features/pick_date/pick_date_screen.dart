import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../model/repository/model/custom_dates.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../model/repository/model/ink_date.dart';
import '../../theme/animation_durations.dart';
import '../../theme/app_colors.dart';
import '../../theme/spacing.dart';
import '../../utils/table_calendar_utils.dart';
import '../../utils/utils.dart';
import '../../widgets/ink_date_elevated_button.dart';
import '../../widgets/ink_date_snack_bar.dart';
import '../../widgets/loading_screen.dart';
import 'pick_date_view_model.dart';

class PickDateScreen extends StatefulWidget {
  const PickDateScreen({Key? key}) : super(key: key);

  @override
  State<PickDateScreen> createState() => _PickDateScreenState();
}

class _PickDateScreenState extends State<PickDateScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final PickDateViewModel pickDateViewModel =
        context.read<PickDateViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await pickDateViewModel.getInkDate();
        await pickDateViewModel.getInkDates();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<PickDateViewModel>(
      builder: (BuildContext context, PickDateViewModel value, Widget? child) {
        if (value.state == PickDateViewState.error) {
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
        if (value.state == PickDateViewState.loading) {
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

        if (value.state == PickDateViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
            },
          );
          return _Body(
            inkDate: value.inkDate!,
            inkDates: value.inkDates ?? <CustomInkDate>[],
            localizations: localizations,
            value: value,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.localizations,
    required this.value,
    required this.inkDate,
    required this.inkDates,
  }) : super(key: key);

  final AppLocalizations localizations;
  final PickDateViewModel value;
  final InkDate inkDate;
  final List<CustomInkDate> inkDates;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  static const String _kCustomInkDates = 'customInkDates';

  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;

  late List<CustomInkDate> _inkDates;

  List<CustomDates>? _selections;

  @override
  void initState() {
    _selectedDay = _focusedDay;

    _inkDates = widget.value.queryWhereCustomInkDate(
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    _selections = widget.value.queryWhereCurrentDay(
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkGreen,
        centerTitle: true,
        title: Text(
          widget.localizations.pickDate,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          Spacing.medium,
        ),
        child: Column(
          children: <Widget>[
            TableCalendar<Event>(
              calendarBuilders: CalendarBuilders<Event>(
                markerBuilder:
                    (BuildContext context, DateTime date, List<Event> events) {
                  return widget.value.queryWhereCustomInkDateLength(
                                inkDates: widget.inkDates,
                                time: date,
                              ) <=
                              2 &&
                          widget.value.queryWhereCustomInkDateLength(
                                inkDates: widget.inkDates,
                                time: date,
                              ) >
                              0
                      ? date == _selectedDay
                          ? const SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                color: AppColors.mediumOccupancyCalendar,
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              height: 30.0,
                              margin: const EdgeInsets.only(
                                  bottom: Spacing.medium - 3.0),
                              width: 30.0,
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                      : widget.value.queryWhereCustomInkDateLength(
                                inkDates: widget.inkDates,
                                time: date,
                              ) >=
                              3
                          ? date == _selectedDay
                              ? const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGreen,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  height: 30.0,
                                  margin: const EdgeInsets.only(
                                      bottom: Spacing.medium - 3.0),
                                  width: 30.0,
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                          : const SizedBox();
                },
              ),
              calendarFormat: _calendarFormat,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                  color: AppColors.darkGreen,
                  shape: BoxShape.circle,
                ),
                todayDecoration: const BoxDecoration(color: Colors.transparent),
              ),
              firstDay: kFirstDay,
              focusedDay: _focusedDay,
              headerStyle: const HeaderStyle(
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      50.0,
                    ),
                  ),
                ),
                headerMargin: EdgeInsets.only(
                  bottom: Spacing.medium,
                ),
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                formatButtonShowsNext: false,
              ),
              lastDay: kLastDay,
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                if (DateTime.now().isSameDate(selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selections = widget.value.queryWhereCurrentDay(
                      inkDates: widget.inkDates,
                      time: selectedDay,
                    );
                    widget.inkDate.startDate = _selectedDay!;
                  });

                  widget.value.saveInkDateStorage(widget.inkDate);
                } else {
                  if (DateTime.now().isBefore(selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _inkDates = widget.value.queryWhereCustomInkDate(
                        inkDates: widget.inkDates,
                        time: selectedDay,
                      );
                      _selections = widget.value.queryWhereCurrentDay(
                        inkDates: widget.inkDates,
                        time: selectedDay,
                      );
                      widget.inkDate.startDate = _selectedDay!;
                    });

                    widget.value.saveInkDateStorage(widget.inkDate);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      showInkDateSnackBar('Fecha no valida'),
                    );
                    setState(() {
                      _selectedDay = DateTime.now();
                      _focusedDay = DateTime.now();
                      _selections = widget.value.queryWhereCurrentDay(
                        inkDates: widget.inkDates,
                        time: selectedDay,
                      );
                      widget.inkDate.startDate = _selectedDay!;
                    });
                    widget.value.saveInkDateStorage(widget.inkDate);
                  }
                }
              },
              onFormatChanged: (CalendarFormat format) {
                if (_calendarFormat != format) {
                  setState(
                    () {
                      _calendarFormat = format;
                    },
                  );
                }
              },
              selectedDayPredicate: (DateTime day) =>
                  isSameDay(_selectedDay, day),
            ),
            const SizedBox(
              height: Spacing.small,
            ),
            InkDateElevatedButton(
              backgroundColor: AppColors.darkGreen,
              text: widget.localizations.pickAnHour,
              onTap: () async {
                final TimeOfDay? startTime = await showTimePicker(
                  context: context,
                  helpText: widget.localizations.startHour,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.darkGreen,
                          background: AppColors.darkGreen,
                          onBackground: AppColors.darkGreen,
                          onPrimaryContainer: AppColors.darkGreen,
                          primaryContainer: AppColors.darkGreen,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (startTime == null) {
                  return;
                }
                widget.inkDate.startDate = DateTime(
                  _focusedDay.year,
                  _focusedDay.month,
                  _focusedDay.day,
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
                    helpText: widget.localizations.validateDate,
                    initialTime: endTime,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.golden,
                            background: AppColors.golden,
                            onBackground: AppColors.golden,
                            onPrimaryContainer: AppColors.golden,
                            primaryContainer: AppColors.golden,
                            secondaryContainer: AppColors.golden,
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
                widget.inkDate.endDate = DateTime(
                  _focusedDay.year,
                  _focusedDay.month,
                  _focusedDay.day,
                  endTime.hour,
                  endTime.minute,
                );
                widget.value.saveInkDateStorage(widget.inkDate);
              },
            ),
            const SizedBox(
              height: Spacing.large,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selections!.length,
                itemBuilder: (_, int index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _selections![index].date,
                            textAlign: TextAlign.center,
                          ),
                          if (_selections![index].name != null)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                color: AppColors.darkGreen,
                              ),
                              height: 50.0,
                              width: 281.0,
                              child: _selections![index].name == null
                                  ? null
                                  : Center(
                                      child: Text(
                                        _selections![index].name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      endIndent: 10,
                      height: 0,
                      indent: 55,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: Spacing.medium,
            ),
            InkDateElevatedButton(
              backgroundColor: AppColors.darkGreen,
              text: widget.localizations.pickAPlace,
              onTap: () {
                if (widget.inkDate.endDate.hour >
                    widget.inkDate.startDate.hour) {
                  Navigator.of(context).pushNamed(
                    NamedRoute.pickPlace,
                    arguments: {_kCustomInkDates: _inkDates},
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    showInkDateSnackBar(widget.localizations.validateHour),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
