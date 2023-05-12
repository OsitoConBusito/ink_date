import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../generated/l10n.dart';
import '../../../core/navigation/named_route.dart';
import '../../../model/repository/model/custom_ink_date.dart';
import '../../../model/repository/model/tattooist.dart';
import '../../../theme/animation_durations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_images.dart';
import '../../../theme/icon_size.dart';
import '../../../theme/spacing.dart';
import '../../../utils/table_calendar_utils.dart';
import '../../../utils/utils.dart';
import '../../../widgets/ink_date_elevated_button.dart';
import '../../../widgets/loading_screen.dart';
import '../../../widgets/person_icon.dart';
import '../detail_place/detail_place_view_model.dart';
import '../home_admin_view_model.dart';
import 'detail_ink_date_view_model.dart';

class DetailInkDateScreen extends StatefulWidget {
  const DetailInkDateScreen({
    Key? key,
    required this.currentPlace,
    required this.customInkDates,
    required this.dateTime,
    required this.id,
  }) : super(key: key);

  final int currentPlace;
  final List<CustomInkDate> customInkDates;
  final DateTime dateTime;
  final String id;

  @override
  State<DetailInkDateScreen> createState() => _DetailInkDateScreenState();
}

class _DetailInkDateScreenState extends State<DetailInkDateScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    final DetailInkDateViewModel viewModel =
        context.read<DetailInkDateViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        await viewModel.getInkDates();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Consumer<DetailInkDateViewModel>(
      builder: (
        BuildContext context,
        DetailInkDateViewModel value,
        __,
      ) {
        if (value.state == DetailInkDateViewState.loading) {
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
        } else if (value.state == DetailInkDateViewState.completedCancel) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              context.read<HomeAdminViewModel>().init();
              Navigator.of(context).pushNamed(NamedRoute.homeAdminScreen);
            },
          );
          return const Scaffold();
        } else if (value.state == DetailInkDateViewState.completed) {
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
            dateTime: widget.dateTime,
            inkDates: value.inkDates!,
            inkDatesTattooist: widget.customInkDates,
            localizations: localizations,
            tattooist: value.getTattooist(widget.customInkDates),
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
    required this.inkDatesTattooist,
    required this.localizations,
    required this.tattooist,
    required this.value,
  }) : super(key: key);

  final int currentPlace;
  final DateTime dateTime;
  final Tattooist tattooist;
  final List<CustomInkDate> inkDates;
  final List<CustomInkDate> inkDatesTattooist;
  final AppLocalizations localizations;
  final DetailInkDateViewModel value;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  DateTime? _focusedDay;

  List<CustomInkDate>? _inkDates;

  DateTime? _selectedDay;

  int _currentPage = 0;
  int currentIndex = 0;
  PageController controller = PageController();

  late TextEditingController _aditionalDetailsController;

  Widget dotIndicator(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.small * 1.5),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: _currentPage == index ? Colors.white : Colors.grey,
          shape: BoxShape.circle,
        ),
        duration: const Duration(
          microseconds: AnimationDurations.short - 100,
        ),
        height: 10.0,
        margin: const EdgeInsets.only(
          right: Spacing.small,
        ),
        width: 10.0,
      ),
    );
  }

  @override
  void initState() {
    _focusedDay = widget.dateTime;
    _selectedDay = _focusedDay;

    _aditionalDetailsController = TextEditingController(text: '');

    _inkDates = widget.value.queryWhereCustomInkDate(
      inkDates: widget.inkDates,
      time: _selectedDay!,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: _AppBar(
        currentPlace: widget.currentPlace,
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
                    height: 119.0,
                    width: 119.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.darkGreen,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.beige,
                    ),
                    child: PersonIcon(
                      imageUrl: widget.tattooist.profilePicture,
                      size: IconSize.medium,
                    ),
                  ),
                  const SizedBox(
                    width: Spacing.medium,
                  ),
                  SizedBox(
                    width: 189.0,
                    child: AutoSizeText(
                      widget.tattooist.fullName,
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Spacing.small,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: List<Widget>.generate(
                            widget.inkDatesTattooist.length,
                            (int index) => dotIndicator(index),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: Spacing.medium,
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: widget.inkDatesTattooist.length,
                  onPageChanged: (int index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (_, int index) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 5.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey.shade200,
                          ),
                          height: 300.0,
                          margin: const EdgeInsets.only(
                            left: Spacing.medium,
                            right: Spacing.medium,
                          ),
                          width: 450.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                height: 120.0,
                                margin: const EdgeInsets.only(
                                  left: Spacing.small,
                                  right: Spacing.small,
                                  top: Spacing.xSmall,
                                ),
                                width: constraints.maxWidth,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: Spacing.large,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: Spacing.medium,
                                        top: Spacing.medium,
                                      ),
                                      width: constraints.maxWidth * 0.49,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.inkDatesTattooist[index]
                                                .tattooist.studioName,
                                            style: const TextStyle(
                                              color: AppColors.darkGreen,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Spacing.xSmall,
                                          ),
                                          Text(
                                            '${widget.localizations.space} #${widget.inkDatesTattooist[index].currentPlace}',
                                            style: const TextStyle(
                                              color: AppColors.darkGreen,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Spacing.xSmall,
                                          ),
                                          Text(
                                            Utils.inkDateHour(widget
                                                .inkDatesTattooist[index]),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: Spacing.xLarge + 8.0,
                                        ),
                                        SvgPicture.asset(
                                          AppImages.table_icon,
                                          color: Colors.grey.shade200,
                                          height: 80,
                                          width: 80,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: Spacing.medium,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                height: 140.0,
                                margin: const EdgeInsets.only(
                                  left: Spacing.small,
                                  right: Spacing.small,
                                  top: Spacing.xSmall,
                                ),
                                width: 450.0,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: Spacing.large,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: Spacing.medium,
                                        top: Spacing.medium,
                                      ),
                                      width: constraints.maxWidth * 0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AutoSizeText(
                                            widget.inkDatesTattooist[index]
                                                .customer.fullName,
                                            style: const TextStyle(
                                              color: AppColors.darkGreen,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            wrapWords: false,
                                          ),
                                          const SizedBox(
                                            height: Spacing.xSmall,
                                          ),
                                          Text(
                                            widget.inkDatesTattooist[index]
                                                .customer.phoneNumber,
                                            style: const TextStyle(
                                              color: AppColors
                                                  .mediumOccupancyCalendar,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Spacing.xSmall,
                                          ),
                                          AutoSizeText(
                                            widget.inkDatesTattooist[index]
                                                    .moreDetails!.isEmpty
                                                ? widget.localizations
                                                    .noAdditionalComments
                                                : widget
                                                    .inkDatesTattooist[index]
                                                    .moreDetails!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                            minFontSize: 13,
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        const SizedBox(
                                          height: Spacing.xLarge + 27.0,
                                        ),
                                        SvgPicture.asset(
                                          AppImages.person,
                                          color: Colors.grey.shade200,
                                          height: 80,
                                          width: 80,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.medium),
              Container(
                margin: const EdgeInsets.only(
                  left: Spacing.medium,
                  right: Spacing.medium,
                ),
                child: InkDateElevatedButton(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 350.0,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: Spacing.medium),
                              SvgPicture.asset(
                                AppImages.cancel,
                                height: 50.0,
                                width: 50.0,
                              ),
                              const SizedBox(height: Spacing.small),
                              Text(
                                widget.localizations.cancelDate,
                                style: const TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: Spacing.medium),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.mediumOccupancyCalendar,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: 250.0,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _aditionalDetailsController,
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintText: 'Observaciones',
                                      ),
                                      maxLines: 6,
                                      validator: (String? name) {
                                        if (name == null || name.isEmpty) {
                                          return 'Obligatorio';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Spacing.xLarge),
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: Spacing.xLarge * 3.0,
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      widget.localizations.cancel,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Spacing.small,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await widget.value.cancelInkDate(
                                          id: widget
                                              .inkDatesTattooist[_currentPage]
                                              .id,
                                          observations:
                                              _aditionalDetailsController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      widget.localizations.send,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: AppColors.darkGreen,
                  text: widget.localizations.cancelDate,
                ),
              ),
              const SizedBox(height: Spacing.medium),
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
    required this.currentPlace,
    required this.dateTime,
  }) : super(key: key);

  static const String _kCurrentPlaceNavigator = 'currentPlace';
  static const String _kTimeNavigator = 'time';

  final int currentPlace;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      centerTitle: true,
      leading: InkWell(
        onTap: () {
          context.read<DetailPlaceViewModel>().init();
          Navigator.of(context).pushNamed(
            NamedRoute.detailPlaceScreen,
            arguments: {
              _kCurrentPlaceNavigator: currentPlace,
              _kTimeNavigator: dateTime,
            },
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
