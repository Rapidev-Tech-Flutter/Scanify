import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:scanify/app/modules/home/views/all_scans.dart';
import 'package:scanify/app/static/constants.dart';

import 'package:scanify/app/widgets/my_network_image.dart';


import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Clr.white,
            elevation: 0,
            shadowColor: Clr.transparent,
            scrolledUnderElevation: 0,
            title: MyNetworkImage(
              imageUrl: AssetPath.splashLogo,
              imageType: ImageType.asset,
              height: 29,
              width: 106.94,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 10.h),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Clr.primary,
                borderRadius: BorderRadius.circular(30.r)
              ),
              child: Row(
                children: [
                  buildIconButton(title: 'OCR',icon: AssetPath.ocrIcon,onTap: controller.onOcrTap),
                  buildIconButton(title: 'ID Scan',icon: AssetPath.idScanIcon,onTap: controller.onIdScanTap),
                  buildIconButton(title: 'Single Scan',icon: AssetPath.sScanIcon,onTap: controller.onSingleScanTap),
                  buildIconButton(title: 'Batch Mode',icon: AssetPath.batchIcon,onTap: controller.onBatchScanTap),
                ],
              ),
            ),
          ),
          body: AllScansView()
        );
      }
    );
  }


  Expanded buildIconButton({required String title,required String icon,Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Clr.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon),
              SizedBox(height: 3.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Clr.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

