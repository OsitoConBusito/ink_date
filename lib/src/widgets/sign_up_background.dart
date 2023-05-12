import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

class SignUpBackground extends StatelessWidget {
  const SignUpBackground({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(color: AppColors.backgroundGrey),
        Positioned(
          top: 20.0,
          left: width * 0.2,
          child: SvgPicture.asset(
            'assets/images/background.svg',
            color: AppColors.backgroundIcon,
          ),
        ),
      ],
    );
  }
}
