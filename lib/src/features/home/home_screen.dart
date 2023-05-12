import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../../generated/l10n.dart';
import '../../core/navigation/named_route.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_images.dart';
import '../../theme/icon_size.dart';
import '../../theme/spacing.dart';
import '../../widgets/person_icon.dart';
import '../admin_profile/admin_profile_view_model.dart';
import '../create_date/create_date_view_model.dart';
import '../tatooist_profile/tattoist_profile_view_model.dart';
import 'date_item.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _fabButtonKey = GlobalKey();
  Rect? _fabButtonRect;
  Rect? _pageTransitionRect;
  String? _imageUrl;

  @override
  void initState() {
    final HomeViewModel viewModel = context.read<HomeViewModel>();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        final NavigatorState navigator = Navigator.of(context);
        await viewModel.isAdminLoggedIn();
        if (!viewModel.isAdminLogged!) {
          await viewModel.getInkDates();
          await viewModel.getDataUSer();
        } else {
          if (context.mounted) {
            context.read<HomeViewModel>().init();
            navigator.pushNamed(NamedRoute.homeAdminScreen);
          }
        }
        if (viewModel.isAdminLogged!) {
          _imageUrl = viewModel.admin?.profilePicture;
        } else {
          _imageUrl = viewModel.tattooist?.profilePicture;
        }
      },
    );
    super.initState();
  }

  void _startPageTransition() {
    setState(() {
      _fabButtonRect =
          _getWidgetRect(_fabButtonKey); // Get the Rect of FAB button here.
      _pageTransitionRect =
          _fabButtonRect; // Assign the rect to `_pageTransitionRect` for the ripple effect.
    });
  }

  Rect? _getWidgetRect(GlobalKey globalKey) {
    final RenderObject? renderObject =
        globalKey.currentContext?.findRenderObject();
    final Vector3? translation =
        renderObject?.getTransformTo(null).getTranslation();
    final Size? size = renderObject?.semanticBounds.size;

    if (translation != null && size != null) {
      return Rect.fromLTWH(
          translation.x, translation.y, size.width, size.height);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel value, Widget? child) {
        if (value.state == HomeViewState.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (value.state == HomeViewState.completed) {
            return Scaffold(
              appBar: _HomeAppBar(
                isAdminLoggedIn: value.isAdminLogged!,
                imageUrl: _imageUrl,
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: <Color>[
                          AppColors.lightGrey,
                          AppColors.beige,
                        ],
                        end: Alignment.bottomCenter,
                        stops: <double>[0.8, 1.0],
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (value.inkDates == null || value.inkDates!.isEmpty) {
                        return const Center(
                          //TODO: remove with Empty state
                          child: Text('No tienes citas asignadas aun'),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.all(Spacing.large),
                                  child: SvgPicture.asset(
                                    AppImages.inkDateLogoName,
                                    width: constraints.maxWidth * 0.4,
                                  ),
                                )
                              else
                                const SizedBox(),
                              if (value.inkDates![index].isCanceled)
                                const SizedBox()
                              else
                                DateItem(
                                  dateTimeRange: DateTimeRange(
                                    start: value.inkDates![index].startDate,
                                    end: value.inkDates![index].endDate,
                                  ),
                                ),
                            ],
                          );
                        },
                        itemCount:
                            value.inkDates != null ? value.inkDates!.length : 0,
                        padding:
                            const EdgeInsets.only(bottom: Spacing.xLarge * 2),
                      );
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.darkGreen,
                onPressed: () {
                  context.read<CreateDateViewModel>().init();
                  Navigator.of(context).pushNamed(
                    NamedRoute.createDate,
                  );
                },
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.backgroundGrey,
                  size: IconSize.medium,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          } else {
            return const Scaffold();
          }
        }
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({
    Key? key,
    required this.isAdminLoggedIn,
    this.imageUrl,
  }) : super(key: key);

  final bool isAdminLoggedIn;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      centerTitle: true,
      leading: InkWell(
        onTap: () async {
          final NavigatorState navigator = Navigator.of(context);
          if (isAdminLoggedIn) {
            context.read<AdminProfileViewModel>().init();
            navigator.pushNamed(NamedRoute.adminProfileScreen);
          } else {
            context.read<TattooistProfileViewModel>().init();
            navigator.pushNamed(NamedRoute.tattooistProfileScreen);
          }
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
