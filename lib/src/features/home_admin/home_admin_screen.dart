import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../model/repository/model/custom_ink_date.dart';
import '../../theme/animation_durations.dart';
import '../../theme/app_colors.dart';
import '../../theme/icon_size.dart';
import '../../theme/spacing.dart';
import '../../utils/table_calendar_utils.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/person_icon.dart';
import '../admin_profile/admin_profile_view_model.dart';
import 'home_admin_view_model.dart';
import 'pick_place_admin/pick_place_admin_view_model.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final HomeAdminViewModel viewModel = context.read<HomeAdminViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await viewModel.getDataUSer();
        await viewModel.getInkDates();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<HomeAdminViewModel>(
      builder: (BuildContext context, HomeAdminViewModel value, Widget? child) {
        if (value.state == HomeAdminViewState.loading) {
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
        } else if (value.state == HomeAdminViewState.completed) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              if (_isLoading) {
                Navigator.of(context, rootNavigator: true).pop(context);
              }
              _isLoading = false;
            },
          );
          return _Body(
            localizations: localizations,
            value: value,
            inkDates: value.inkDates!,
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
    required this.localizations,
    required this.value,
    required this.inkDates,
  }) : super(key: key);

  final AppLocalizations localizations;
  final HomeAdminViewModel value;
  final List<CustomInkDate> inkDates;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;

  late List<CustomInkDate> _inkDates;

  @override
  void initState() {
    _selectedDay = _focusedDay;

    _inkDates = widget.value.queryWhereCustomInkDate(
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _HomeAppBar(
        imageUrl: widget.value.admin!.profilePicture,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: Spacing.medium,
            right: Spacing.medium,
            top: Spacing.medium,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: Spacing.large,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 170.0,
                        width: 170.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.darkGreen,
                        ),
                        child: Center(
                          child: widget.value.admin!.placePicture == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 100.0,
                                  child: Text(
                                    widget.localizations.picture.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.golden,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 180.0,
                                    imageUrl: widget.value.admin!.placePicture!,
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            const CircularProgressIndicator(),
                                    width: 180.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: Spacing.medium,
                      ),
                      SizedBox(
                        width: 140.0,
                        child: AutoSizeText(
                          widget.value.admin!.placeName,
                          style: const TextStyle(
                            color: AppColors.golden,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: Spacing.xLarge,
                  ),
                  Card(
                    elevation: 8,
                    color: AppColors.backgroundGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              context.read<PickPlaceAdminViewModel>().init();
                              Navigator.of(context).pushNamed(
                                NamedRoute.pickPlaceAdminScreen,
                                arguments: {'time': _selectedDay},
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                                color: AppColors.darkGreen,
                              ),
                              height: 80.0,
                              width: constraints.maxWidth,
                              child: Center(
                                child: Text(
                                  widget.localizations.selectDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.backgroundGrey,
                              ),
                              color: AppColors.backgroundGrey,
                            ),
                            child: TableCalendar<Event>(
                              calendarBuilders: CalendarBuilders<Event>(
                                markerBuilder: (BuildContext context,
                                    DateTime date, List<Event> events) {
                                  return widget.value
                                                  .queryWhereCustomInkDateLength(
                                                inkDates: widget.inkDates,
                                                time: date,
                                              ) <=
                                              2 &&
                                          widget.value
                                                  .queryWhereCustomInkDateLength(
                                                inkDates: widget.inkDates,
                                                time: date,
                                              ) >
                                              0
                                      ? date == _selectedDay
                                          ? const SizedBox()
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .mediumOccupancyCalendar,
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
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                      : widget.value
                                                  .queryWhereCustomInkDateLength(
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
                                                        BorderRadius.circular(
                                                            60.0),
                                                  ),
                                                  height: 30.0,
                                                  margin: const EdgeInsets.only(
                                                      bottom:
                                                          Spacing.medium - 3.0),
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
                                selectedBuilder: (BuildContext context,
                                    DateTime day, DateTime focusedDay) {
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
                                    margin: const EdgeInsets.only(
                                        bottom: Spacing.medium - 6.0),
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
                                todayDecoration:
                                    BoxDecoration(color: Colors.transparent),
                              ),
                              firstDay: kFirstDay,
                              focusedDay: _focusedDay,
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                decoration: BoxDecoration(
                                  color: AppColors.beige,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      50.0,
                                    ),
                                  ),
                                ),
                                headerMargin: EdgeInsets.only(
                                  bottom: Spacing.small,
                                  top: Spacing.small,
                                ),
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              lastDay: kLastDay,
                              onDaySelected:
                                  (DateTime selectedDay, DateTime focusedDay) {
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      centerTitle: true,
      leading: InkWell(
        onTap: () async {
          context.read<AdminProfileViewModel>().init();
          Navigator.of(context).pushNamed(NamedRoute.adminProfileScreen);
        },
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Spacing.xSmall,
            left: Spacing.xLarge - 2.0,
            right: Spacing.xLarge - 2.0,
            top: Spacing.xSmall,
          ),
          child: PersonIcon(
            imageUrl: imageUrl,
            size: IconSize.xSmall,
          ),
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
