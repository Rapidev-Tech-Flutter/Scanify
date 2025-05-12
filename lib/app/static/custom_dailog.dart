
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/loading_pro.dart';


            
Future<dynamic> buildCustomDialog({
  required String title,
  required String desc,
  String? svgIcon,
  Widget? body,
  Color? okayBtnColor,
  Color? cancelBtnColor,
  Color? svgIconColor,
  required String okayBtnText,
  String? cancelBtnText,
  required Function() onOk,
  bool barrierDismissible = true,
  RxBool? isOkLoading,
  bool isEqualFlex = true,
}) {
  return Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Clr.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: okayBtnColor ?? Clr.primary),
              color: Clr.inputfieldColor,
            ),
            width: .8.sw,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (svgIcon != null) ...[
                    SvgPicture.asset(svgIcon,height: 40.h,width: 40.h, colorFilter: svgIconColor == null ?  null : ColorFilter.mode(svgIconColor, BlendMode.srcIn),),
                    SizedBox(height: 16.h),
                  ],
                  Text(
                    title.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: Clr.textColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    desc.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Clr.subtextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (cancelBtnText != null) ...[
                        Expanded(
                          flex: 1,
                          child: DialogButton(
                            title: cancelBtnText.tr,
                            onTap: Get.back,
                            bgColor: cancelBtnColor ?? Clr.transparent,
                          ),
                        ),
                        SizedBox(width: 16.w),
                      ],
                      Expanded(
                        flex: isEqualFlex ? 1 : 2,
                        child: Obx(()=> (isOkLoading?.value ?? (false.obs).value) ?  LoadingPro(backgroundColor: Clr.transparent) : DialogButton(
                            title: okayBtnText.tr,
                            onTap: onOk,
                            bgColor: okayBtnColor ?? Clr.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: barrierDismissible && !(isOkLoading?.value ?? false),
  );
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.bgColor,
    this.borderRadius,
  });
  final String title;
  final Function() onTap;
  final Color bgColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius ?? 56.r),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            border: Border.all(color: bgColor != Clr.transparent ? Clr.transparent : Clr.subtextColor.withValues(alpha:0.5)),
            borderRadius: BorderRadius.circular(borderRadius ?? 56.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 14.sp,
              color: bgColor == Clr.transparent ? Clr.textColor : Clr.white,
            ),
          ),
        ),
      ),
    );
  }
}

