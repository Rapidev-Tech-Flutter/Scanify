import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/my_network_image.dart';
import 'package:scanify/app/widgets/submit_button.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OnboardingController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: 1.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 610.h,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: controller.pageController,
                          allowImplicitScrolling: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.obData.length,
                          itemBuilder: (context,index) {
                            final data = controller.obData[index];
                            return buildInfoSection(data);
                          }
                        ),
                        Positioned(
                          top: 0,
                          right: 31.w,
                          child: GestureDetector(
                            onTap: controller.onSkipPressed,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Clr.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ).paddingOnly(top: 20.h),
                  Row(
                    children: [
                      if(controller.currentIndex != controller.obData.length-1) Expanded(
                        child: Row(
                          children: List.generate(
                            controller.obData.length-1,
                            (index) {
                              bool isActive = controller.currentIndex == index;
                              return Container(
                                height: 8.h,
                                width: (isActive ? 40 : 8).w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  color: isActive ? Clr.primary : Clr.grey,
                                  borderRadius: BorderRadius.circular(20.r)
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SubmitButton(
                          title: controller.currentIndex == controller.obData.length-1 ? 'Get started' : 'Next',
                          width: 144,
                          radius: 30,
                          onTap: controller.onNextTap,
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 31.w,vertical: 10.h),
                  SizedBox(),
                ],
              ),
            ),
          )
        );
      },
    );
  }


  Column buildInfoSection(Map<String,dynamic> data) {
    return Column(
      children: [
         Center(
          child: SizedBox(
            height: 396.82.h,
            width: 313.w,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                MyNetworkImage(
                  imageUrl: AssetPath.obBackground,
                  imageType: ImageType.asset,
                ),
                MyNetworkImage(
                  imageUrl: data['image'],
                  imageType: ImageType.asset,
                  fit: BoxFit.scaleDown,
                  height: 322,
                  width: 283,
                ),
              ],
            ),
          ).paddingOnly(bottom: 45.h),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 31.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['title'],
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 344.w,
                  child: Text(
                    data['subtitle'],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: Clr.colorSubtitle
                    ),
                  ),
                ),
              ],
            ), 
          ),
        ),
      ],
    );
  }
}
