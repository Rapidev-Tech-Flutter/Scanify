import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


//----------------------loader----------------------
Widget loader = SpinKitCircle(
  color: Clr.primary,
  size: 30.0.w,
);

class Clr {
  const Clr._();

  static const primary = Color(0xFF539DDB);
  static const white = Colors.white;
  static const transparent = Colors.transparent;
 

}