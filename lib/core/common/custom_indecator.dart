import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomIndecator extends StatelessWidget {
  const CustomIndecator({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitWanderingCubes(
      color: Theme.of(context).primaryColor,
      size: size,
    );
  }
}
