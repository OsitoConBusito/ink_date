import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../generated/l10n.dart';
import '../../../core/navigation/named_route.dart';
import '../../../model/repository/model/custom_dates.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../theme/animation_durations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/icon_size.dart';
import '../../../theme/spacing.dart';
import '../../../utils/table_calendar_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/loading_screen.dart';
import '../detail_ink_date/detail_ink_date_view_model.dart';
import '../pick_place_admin/pick_place_admin_view_model.dart';
import 'detail_place_view_model.dart';

class DetailPlaceScreen extends StatefulWidget {
  const DetailPlaceScreen({
    Key? key,
    required this.currentPlace,
    required this.time,
  }) : super(key: key);

  final int currentPlace;
  final DateTime time;

  @override
  State<DetailPlaceScreen> createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final DetailPlaceViewModel viewModel = context.read<DetailPlaceViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await viewModel.getInkDates();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<DetailPlaceViewModel>(
      builder: (
        BuildContext context,
        DetailPlaceViewModel value,
        Widget? child,
      ) {
        if (value.state == DetailPlaceViewState.loading) {
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
        } else if (value.state == DetailPlaceViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
            },
          );
          return _Body(
            currentPlace: widget.currentPlace,
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
  final DetailPlaceViewModel value;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  DateTime? _focusedDay;

  List<CustomInkDate>? _inkDates;

  List<CustomDates>? _selections;

  DateTime? _selectedDay;

  static const String _kCurrentPlaceNavigator = 'currentPlace';
  static const String _kCustomInkDates = 'customInkDates';
  static const String _kId = 'id';
  static const String _kTimeNavigator = 'time';

  @override
  void initState() {
    _focusedDay = widget.dateTime;
    _selectedDay = _focusedDay;

    _inkDates = widget.value.queryWhereCustomInkDate(
      currentPlace: widget.currentPlace,
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    _selections = widget.value.queryWhereCurrentDay(
      currentPlace: widget.currentPlace,
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        dateTime: _selectedDay!,
      ),
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
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) =>
                      setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selections = widget.value.queryWhereCurrentDay(
                      currentPlace: widget.currentPlace,
                      inkDates: widget.inkDates,
                      time: selectedDay,
                    );
                  }),
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
                    width: Spacing.xLarge,
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
                        child: AutoSizeText(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        child: AutoSizeText(
                          Utils.monthActuality(_selectedDay!.month),
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 56.0,
                            fontWeight: FontWeight.bold,
                          ),
                          wrapWords: false,
                        ),
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
                ],
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.grey.shade200,
                ),
                height: constraints.maxHeight * 0.49,
                margin: const EdgeInsets.only(
                  left: Spacing.medium,
                  right: Spacing.medium,
                ),
                padding: const EdgeInsets.only(
                  top: Spacing.medium,
                  left: Spacing.medium,
                  right: Spacing.medium,
                ),
                width: constraints.maxWidth,
                child: ListView.builder(
                  itemCount: _selections!.length,
                  itemBuilder: (_, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (index == 0)
                        const SizedBox(
                          height: Spacing.medium,
                        )
                      else
                        const SizedBox(),
                      if (index == 0)
                        Text(
                          '${widget.localizations.space} ${widget.currentPlace}',
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const SizedBox(),
                      InkWell(
                        onTap: _selections![index].tattooistId == null
                            ? null
                            : () {
                                context.read<DetailInkDateViewModel>().init();
                                Navigator.of(context).pushNamed(
                                  NamedRoute.detailInkDateScreen,
                                  arguments: {
                                    _kCurrentPlaceNavigator:
                                        widget.currentPlace,
                                    _kId: _selections![index].id,
                                    _kTimeNavigator: _selectedDay,
                                    _kCustomInkDates:
                                        widget.value.queryWhereTattooist(
                                      inkDates: widget.inkDates,
                                      place: widget.currentPlace,
                                      tattooistid:
                                          _selections![index].tattooistId!,
                                      time: _selectedDay!,
                                    )
                                  },
                                );
                              },
                        child: SizedBox(
                          height: 50.0,
                          child: Row(
                            children: <Widget>[
                              Text(
                                _selections![index].date,
                                style: const TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(
                                width: Spacing.medium,
                              ),
                              if (_selections![index].name == null)
                                const SizedBox()
                              else
                                Column(
                                  children: [
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
                                      width: constraints.maxWidth * 0.65,
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
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 2,
                        indent: 55,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
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
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      centerTitle: true,
      leading: InkWell(
        onTap: () {
          context.read<PickPlaceAdminViewModel>().init();
          Navigator.of(context).pushNamed(
            NamedRoute.pickPlaceAdminScreen,
            arguments: {'time': dateTime},
          );
        },
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
