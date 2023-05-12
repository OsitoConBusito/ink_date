import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PersonIcon extends StatelessWidget {
  const PersonIcon({
    Key? key,
    this.imageUrl,
    required this.size,
  }) : super(key: key);

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl != null
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              height: size * 0.2,
              imageUrl: imageUrl!,
              placeholder: (BuildContext context, String url) =>
                  const CircularProgressIndicator(),
              width: size * 0.2,
            )
          : CircleAvatar(
              backgroundColor: AppColors.backgroundIcon,
              minRadius: size,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: size,
              ),
            ),
    );
  }
}
