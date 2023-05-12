import 'package:flutter/material.dart';

import '../theme/app_animations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.asset(AppAnimations.loader),
      ),
    );
  }
}
