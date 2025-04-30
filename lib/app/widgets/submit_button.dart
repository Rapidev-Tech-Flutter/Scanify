import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanify/app/static/constants.dart';

import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scanify/app/static/extensions.dart';



class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.title,
    this.titleWidget,
    this.bgColor,
    this.onTap,
    this.width,
    this.radius,
    this.height = 48,
    this.bdColor,
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.postFix,
    this.isPostIcon = false, 
    this.preFix, 
    this.icon, this.iconColor, 
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding, this.subtitle, this.subTitleColor, this.subTitleFontSize, this.subTitleFontWeight, this.margin,
  });
  final Color? bgColor;
  final String title;
  final String? subtitle;
  final Widget? titleWidget;
  final double height;
  final double? width;
  final double? radius;
  final Color? bdColor;
  final Color? textColor;
  final Color? subTitleColor;
  final double? textSize;
  final double? subTitleFontSize;
  final FontWeight? fontWeight;
  final FontWeight? subTitleFontWeight;
  final Function()? onTap;
  final Widget? postFix;
  final Widget? preFix;

  final bool isPostIcon;
  final IconData? icon;
  final Color? iconColor;

  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;  
  final EdgeInsets? margin; 
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: onTap ?? () {},
      child: Container(
        width: width?.w ?? double.infinity,
        alignment: Alignment.center,
        height: height.h,
        decoration: BoxDecoration(
          color: bgColor ?? Clr.primary,
          border: Border.all(color: bdColor ?? bgColor ?? Clr.primary, width: 1.w),
          borderRadius: BorderRadius.circular((radius ?? 16).r),
        ),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(preFix != null || (!isPostIcon && icon != null)) Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: preFix ?? (Icon(icon,color: iconColor ?? Clr.white)),
            ),
            titleWidget ?? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Text(
                    title.tr,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: textColor ?? Clr.white,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      fontSize: (textSize ?? 18).sp,
                    ),
                  ),
                  if(subtitle.isNotNullOrNotEmpty) Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      subtitle!.tr,
                      style: TextStyle(
                        fontSize: (subTitleFontSize ?? 12).sp,
                        fontWeight: subTitleFontWeight ?? FontWeight.w500,
                        color: subTitleColor ?? Clr.white.withValues(alpha: .5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(postFix != null || (isPostIcon && icon != null)) Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: postFix ?? (Icon(icon,color: iconColor ?? Clr.white)),
            ),
          ],
        )
      ),
    );
  }
}