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
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: SizedBox(
                      height: 396.82.h,
                      width: 313.w,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          MyNetworkImage(
                            imageUrl: 'assets/images/ob-0.png',
                            imageType: ImageType.asset,
                          ),
                          MyNetworkImage(
                            imageUrl: controller.obData[controller.currentIndex]['image'],
                            imageType: ImageType.asset,
                            fit: BoxFit.scaleDown,
                            height: 322,
                            width: 283,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
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
                    ).paddingOnly(bottom: 45.h),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 31.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.obData[controller.currentIndex]['title'],
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).paddingOnly(bottom: 24.h),
                        Text(
                          controller.obData[controller.currentIndex]['subtitle'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ).paddingOnly(bottom: 93.h),
                        Row(
                          children: [
                            
                            SubmitButton(
                              title: 'Next',
                              width: 144,
                              radius: 30,
                            )
                          ],
                        )
                      ],
                    ), 
                  ),

                ],
              ),
            ),
          )
        );
      },
    );
  }
}
