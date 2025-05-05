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
  
  static const unSelectedNavBarItemColor = Color(0xFFBBBABA);
  static const selectedNavBarItemColor = primary;
  static const colorSubtitle = Color(0xFF757373);
  static const inputfieldColor = Color(0xFFF5F5F5);
  static const textColor = Color(0xFF000000);
  static const subtextColor = Color(0xFFBBBABA);

  static const grey = Color(0xFFD9D9D9);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Colors.transparent;
}


class AssetPath {
   const AssetPath._();

   static const splashLogo = 'assets/images/app_logo.png';

   static const obBackground = 'assets/images/ob-0.png';
   static const Onboarding1 = 'assets/images/ob-1.png';
   static const Onboarding2 = 'assets/images/ob-2.png';
   static const Onboarding3 = 'assets/images/ob-3.png';
   static const Onboarding4 = 'assets/images/ob-4.png';

   static const homeIcon = 'assets/svgs/home.svg';
   static const importImageIcon = 'assets/svgs/import.svg';
   static const scanIcon = 'assets/svgs/scan.svg';

   static const ocrIcon = 'assets/svgs/ocr.svg';
   static const idScanIcon = 'assets/svgs/idscan.svg';
   static const sScanIcon = 'assets/svgs/sscan.svg';
   static const batchIcon = 'assets/svgs/batch.svg';

   static const addFileIcon = 'assets/svgs/addFile.svg';
   static const refreshIcon = 'assets/svgs/refresh.svg';
}