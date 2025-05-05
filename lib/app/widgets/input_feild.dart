// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';



class InputField extends StatelessWidget {
  final String hintText;
  final Function? validator;
  final void Function(String?)? saved;
  final void Function(String)? submitted;
  final void Function(String)? onChanged;
  final Function()? onTap;
  final TextEditingController inputController;
  final TextInputType? type;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool secure;
  final IconData? suffixIcon;
  final Widget? suffix;
  final bool readOnly;
  final Function? suffixPress;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Color? bgColor;
  final Color? bdColor;
  final double? bdRadius;
  final Color? suffixColor;
  final Color? prefixColor;
  final Color? hintColor;
  final Color? textColor;
  final IconData? prefixIconData;
  final Widget? prefixIcon;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? errorStyle;
  final int? maxErrorLines;
  final bool autoValidate;
  final EdgeInsets? contentPadding;
  final Function()? onEditingComplete;

  final String? title;
  final bool titleHasTopPadding;
  final double? titleFontSize;
  final double? titleTopPadding;
  final double? titleBottomPadding;
  final Color? titleColor;
  final FontWeight? titleFontWeight;
  final TextStyle? titleTextStyle;
  final String? title2;
  final double? title2FontSize;
  final Color? title2Color;
  final FontWeight? title2FontWeight;
  final TextStyle? title2TextStyle;
  final bool autoFocus;

  const InputField({
    super.key,
    required this.hintText,
    this.validator,
    required this.inputController,
    this.onEditingComplete,
    this.contentPadding,
    this.inputFormatters,
    this.autoFocus = false,
    this.onTap,
    this.type,
    this.focusNode,
    this.submitted,
    this.saved,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxErrorLines = 10,
    this.maxLength,
    this.suffixPress,
    this.onChanged,
    this.bgColor,
    this.bdColor,
    this.bdRadius,
    this.suffixColor,
    this.prefixColor,
    this.hintColor,
    this.textColor,
    this.prefixIconData,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.textInputAction,
    this.errorStyle,
    this.readOnly = false,
    this.autoValidate = true,
    this.titleHasTopPadding = true,
    this.secure = false,
    this.title,
    this.titleFontSize,
    this.titleColor,
    this.titleFontWeight,
    this.titleTextStyle,
    this.title2,
    this.title2FontSize,
    this.title2Color,
    this.title2FontWeight,
    this.title2TextStyle,
    this.titleTopPadding,
    this.titleBottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          FieldTitle(
            titleHasTopPadding: titleHasTopPadding,
            title: title,
            titleFontSize: titleFontSize,
            titleColor: titleColor,
            titleFontWeight: titleFontWeight,
            titleTextStyle: titleTextStyle,
            optionalTitle: title2,
            optionalTitleFontSize: title2FontSize,
            optionalTitleColor: title2Color,
            optionalTitleFontWeight: title2FontWeight,
            optionalTitleTextStyle: title2TextStyle,
            topPadding: titleTopPadding,
            bottomPadding: titleBottomPadding,
          ),
        TextFormField(
          onTap: onTap,
          canRequestFocus: readOnly ? false : true,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: submitted,
          autofocus: autoFocus,
          onSaved: saved,
          focusNode: focusNode,
          textInputAction: textInputAction ?? TextInputAction.done,
          obscureText: secure,
          readOnly: readOnly,
          keyboardType: type,
          controller: inputController,
          autovalidateMode:
              autoValidate ? AutovalidateMode.onUserInteraction : null,
          inputFormatters: [
            ...(inputFormatters ?? []),
            NoWhitespaceInputFormatter(),
          ],
          validator: (value) => validator == null ? null : validator!(value),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: textColor ?? Clr.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            suffixIcon: suffixIcon != null ? GestureDetector(  
              onTap: suffixPress as Function()?,  
              child: Icon(
                suffixIcon,
                color: suffixColor ?? Clr.colorSubtitle,
                size: 22.h,
              ),
            ) : null,
            prefixIcon: prefixIcon ?? (prefixIconData != null ? Icon(
              prefixIconData,
              color: prefixColor ?? Clr.colorSubtitle,
              size: 24.h,
            ) : null),
            prefix: prefix, 
            suffix: suffix, 
            fillColor: bgColor ?? Clr.inputfieldColor,
            filled: true,
            hintStyle: TextStyle(
              color: hintColor ?? Clr.colorSubtitle,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            hintText: hintText.tr,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular((bdRadius ?? 10).r),
              borderSide: BorderSide(color: (bdColor ?? Clr.inputfieldColor).withValues(alpha: .5), width: 1.0.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular((bdRadius ?? 10).r),
              borderSide: BorderSide(color: Colors.red.withValues(alpha: .5), width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular((bdRadius ?? 10).r),
              borderSide: BorderSide(color: bdColor ?? Clr.inputfieldColor, width: 2.0.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular((bdRadius ?? 10).r),
              borderSide: BorderSide(color: Colors.red, width: 2.w),
            ),
            errorStyle: errorStyle ?? TextStyle(
              color: Colors.red,
              letterSpacing: 0.00,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            errorMaxLines: maxErrorLines,
          ),
        ),
      ],
    );
  }
}

class NoWhitespaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is only whitespace, revert to the old value.
    if (newValue.text.trim().isEmpty && newValue.text.isNotEmpty) {
      return oldValue;
    }
    return newValue;
  }
}

class FieldTitle extends StatelessWidget {
  final String? title;
  final bool titleHasTopPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? titleFontSize;
  final Color? titleColor;
  final FontWeight? titleFontWeight;
  final TextStyle? titleTextStyle;
  final String? optionalTitle;
  final double? optionalTitleFontSize;
  final Color? optionalTitleColor;
  final FontWeight? optionalTitleFontWeight;
  final TextStyle? optionalTitleTextStyle;

  const FieldTitle({
    super.key,
    this.titleHasTopPadding = true,
    this.topPadding,
    this.bottomPadding,
    this.title, 
    this.titleFontSize, 
    this.titleColor, 
    this.titleFontWeight, 
    this.titleTextStyle, 
    this.optionalTitle, 
    this.optionalTitleFontSize, 
    this.optionalTitleColor, 
    this.optionalTitleFontWeight, 
    this.optionalTitleTextStyle, 
  });

  // var isError = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(titleHasTopPadding) SizedBox(height: (topPadding ?? 16).h),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title?.tr ?? '',
              style: titleTextStyle ?? TextStyle(
                fontWeight: titleFontWeight ?? FontWeight.w500,
                fontSize: (titleFontSize ?? 14).sp,
                color: titleColor ?? Clr.textColor,
              ),
            ),
            if(optionalTitle != null)
              Text(
                optionalTitle?.tr ?? '',
                style: optionalTitleTextStyle ?? TextStyle(
                  fontWeight: optionalTitleFontWeight ?? FontWeight.w500,
                  fontSize: (optionalTitleFontSize ?? 14).sp,
                  color: optionalTitleColor ?? Clr.colorSubtitle,
                ),
              )
          ],
        ),
        SizedBox(height: (bottomPadding ?? 8).h),
      ],

    );
  }
}