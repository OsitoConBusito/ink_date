import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../generated/l10n.dart';
import '../../../core/navigation/named_route.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../theme/animation_durations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/icon_size.dart';
import '../../../theme/spacing.dart';
import '../../../utils/table_calendar_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/loading_screen.dart';
import '../detail_place/detail_place_view_model.dart';
import 'pick_place_admin_view_model.dart';

class PickPlaceAdmin extends StatefulWidget {
  const PickPlaceAdmin({
    Key? key,
    required this.time,
  }) : super(key: key);

  final DateTime time;

  @override
  State<PickPlaceAdmin> createState() => _PickPlaceAdminState();
}

class _PickPlaceAdminState extends State<PickPlaceAdmin> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    final PickPlaceAdminViewModel viewModel =
        context.read<PickPlaceAdminViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await viewModel.getCurrentPlaces();
        await viewModel.getInkDates();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<PickPlaceAdminViewModel>(
      builder:
          (BuildContext context, PickPlaceAdminViewModel value, Widget? child) {
        if (value.state == PickPlaceAdminViewState.loading) {
          _isLoading = true;
          SchedulerBinding.instance.addPostFrameCallback(
            (_) async {
              await showGeneralDialog(
                barrierColor: Colors.black12.withOpacity(0.3),
                barrierDismissible: false,
                context: context,
                pageBuilder: (_, __, ___) => const Expanded(
                  child: LoadingScreen(),
                ),
                transitionDuration:
                    const Duration(milliseconds: AnimationDurations.medium),
              );
            },
          );
          return const Scaffold();
        } else if (value.state == PickPlaceAdminViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
            },
          );
          return _Body(
            currentPlace: value.currentPlace!,
            dateTime: widget.time,
            inkDates: value.inkDates!,
            localizations: localizations,
            value: value,
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.currentPlace,
    required this.dateTime,
    required this.inkDates,
    required this.localizations,
    required this.value,
  }) : super(key: key);

  final int currentPlace;
  final DateTime dateTime;
  final List<CustomInkDate> inkDates;
  final AppLocalizations localizations;
  final PickPlaceAdminViewModel value;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  int? _currentPlace;

  List<bool>? _currentPlaces;

  DateTime? _focusedDay;

  List<CustomInkDate>? _inkDates;

  DateTime? _selectedDay;

  static const String _timeNavigator = 'time';

  static const String _currentPlaceNavigator = 'currentPlace';

  @override
  void initState() {
    _focusedDay = widget.dateTime;
    _selectedDay = _focusedDay;

    _currentPlaces =
        List<bool>.generate(widget.currentPlace, (int index) => false);

    _inkDates = widget.value.queryWhereCustomInkDate(
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.only(
                  bottom: Spacing.medium,
                  left: Spacing.xLarge,
                  right: Spacing.xLarge,
                ),
                child: TableCalendar<Event>(
                  calendarFormat: CalendarFormat.week,
                  calendarBuilders: CalendarBuilders<Event>(
                    markerBuilder: (BuildContext context, DateTime date,
                        List<Event> events) {
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                      height: 30.0,
                                      margin: const EdgeInsets.only(
                                          bottom: Spacing.medium - 3.0),
                                      width: 30.0,
                                      child: Center(
                                        child: Text(
                                          date.day.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                              : const SizedBox();
                    },
                    selectedBuilder: (BuildContext context, DateTime day,
                        DateTime focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          color: AppColors.beige,
                          shape: BoxShape.circle,
                        ),
                        height: 35.0,
                        margin:
                            const EdgeInsets.only(bottom: Spacing.medium - 6.0),
                        width: 35.0,
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.transparent),
                  ),
                  firstDay: kFirstDay,
                  focusedDay: _focusedDay!,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  lastDay: kLastDay,
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(
                      () {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      },
                    );
                  },
                  selectedDayPredicate: (DateTime day) =>
                      isSameDay(_selectedDay, day),
                ),
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: Spacing.large - 3.0,
                  ),
                  Container(
                    height: 160.0,
                    width: 160.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.beige,
                    ),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 100.0,
                        child: Text(
                          _selectedDay!.day.toString(),
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 86.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Spacing.medium,
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          Utils.monthActuality(_selectedDay!.month),
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),
                          wrapWords: false,
                        ),
                        Text(
                          _selectedDay!.year.toString(),
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
              InkWell(
                onTap: () {
                  context.read<DetailPlaceViewModel>().init();
                  Navigator.of(context).pushNamed(
                    NamedRoute.detailPlaceScreen,
                    arguments: {
                      _currentPlaceNavigator: _currentPlace,
                      _timeNavigator: _selectedDay,
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Colors.grey.shade200,
                  ),
                  height: 50.0,
                  width: constraints.maxWidth * 0.9,
                  child: Center(
                    child: Text(
                      widget.localizations.reviewSpace,
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: constraints.maxWidth * 0.3,
                  ),
                  itemCount: _currentPlaces!.length,
                  padding: const EdgeInsets.only(
                    bottom: Spacing.medium,
                  ),
                  itemBuilder: (_, int index) => InkWell(
                    onTap: () {
                      for (int i = 0; i < _currentPlaces!.length; i++) {
                        if (i == index) {
                          setState(
                            () => _currentPlaces![index] =
                                !_currentPlaces![index],
                          );
                          if (_currentPlaces![index]) {
                            _currentPlace = index + 1;
                          } else {
                            _currentPlace = 0;
                          }
                        } else {
                          setState(
                            () => _currentPlaces![i] = false,
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.darkGreen,
                        ),
                        borderRadius: BorderRadius.circular(60.0),
                        color: _currentPlaces![index] == true
                            ? AppColors.beige
                            : widget.value.queryWhereCustomInkDatePlace(
                                            inkDates: widget.inkDates,
                                            place: index + 1,
                                            time: _selectedDay!) <=
                                        2 &&
                                    widget.value.queryWhereCustomInkDatePlace(
                                            inkDates: widget.inkDates,
                                            place: index + 1,
                                            time: _selectedDay!) >
                                        0
                                ? AppColors.mediumOccupancyCalendar
                                : widget.value.queryWhereCustomInkDatePlace(
                                            inkDates: widget.inkDates,
                                            place: index + 1,
                                            time: _selectedDay!) >=
                                        3
                                    ? AppColors.darkGreen
                                    : null,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: Spacing.small,
                        left: Spacing.medium,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _currentPlaces![index] == true
                                ? AppColors.darkGreen
                                : widget.value.queryWhereCustomInkDatePlace(
                                            inkDates: widget.inkDates,
                                            place: index + 1,
                                            time: _selectedDay!) >=
                                        3
                                    ? Colors.white
                                    : AppColors.darkGreen,
                            fontSize: 26,
                          ),
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
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      centerTitle: true,
      leading: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(NamedRoute.homeAdminScreen),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: IconSize.small,
        ),
      ),
      leadingWidth: 100,
      title: Text(
        AppLocalizations.of(context).yourDates,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
