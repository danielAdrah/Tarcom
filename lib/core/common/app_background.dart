// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget? child;
  final String imagePath;

  const AppBackground({
    super.key,
    this.child,
    this.imagePath = 'assets/img/bg.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
        //dark overlay
        // Positioned.fill(
        //   child: Container(
        //     decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        //   ),
        // ),
        // Content layer
        if (child != null) child!,
      ],
    );
  }
}
