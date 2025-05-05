import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: controller.pages[controller.currentIndex],
          bottomNavigationBar: Container(
            color: Clr.white,
            height: 64.h,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: buildNavBarItem(
                    index: 0,
                    icon: AssetPath.homeIcon,
                    label: 'Home',
                  )
                ),
                Expanded(
                  child: Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.19.w,color: Clr.grey.withValues(alpha: .49))
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      height: 42.18.h,
                      width: 42.18.h,
                      decoration: BoxDecoration(
                        color: Clr.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(AssetPath.scanIcon),
                    ),
                  ),
                ),
                Expanded(
                  child: buildNavBarItem(
                    index: 1,
                    icon: AssetPath.importImageIcon,
                    label: 'Import Images',
                  )
                ),
              ],
            ),
          ),
        );
      }
    );
  }


  buildNavBarItem({required int index, required String label,required String icon}) {
    bool isActive = index == controller.currentIndex;
    Color color = isActive ? Clr.selectedNavBarItemColor : Clr.unSelectedNavBarItemColor;
    return Container(
      color: Clr.transparent,
      child: GestureDetector(
        onTap: () => controller.onNavItemTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon,colorFilter: ColorFilter.mode(color, BlendMode.srcIn),),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ).paddingOnly(top: 4),
          ],
        ),
      ),
    );
  }
}
