import 'package:flutter/material.dart';

enum Slide {
  bottom,
  left,
  right,
  top,
}

extension SlideExtension on Slide {
  Offset get slideSide {
    switch (this) {
      case Slide.bottom:
        return const Offset(0.0, 1.0);
      case Slide.left:
        return const Offset(-1.0, 0.0);
      case Slide.right:
        return const Offset(1.0, 0.0);
      case Slide.top:
        return const Offset(0.0, -1.0);
    }
  }
}

class SlidePageRoute extends PageRouteBuilder<dynamic> {
  SlidePageRoute({
    required this.offset,
    required this.page,
    this.routeName,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: RouteSettings(
            name: routeName,
          ),
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: offset,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
  final Offset offset;
  final Widget page;
  final String? routeName;
}
