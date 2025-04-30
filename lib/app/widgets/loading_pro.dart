import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

class LoadingPro extends StatelessWidget {
  final double? size;
  final bool isLinear;
  final Color? valueColor, backgroundColor;
  final bool? platFormIsIOS;
  final Widget? customLoadingWidget;

  const LoadingPro({
    this.size,
    this.isLinear = false,
    this.valueColor,
    this.backgroundColor,
    this.platFormIsIOS,
    this.customLoadingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return customLoadingWidget??Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: isLinear  ? LinearProgressIndicator(
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor ?? Theme.of(context).primaryColor),
        ) : (platFormIsIOS ?? GetPlatform.isIOS) ? CircleAvatar(
          backgroundColor: backgroundColor ?? Colors.transparent,
          child: CupertinoActivityIndicator(
            color: valueColor ?? Theme.of(context).primaryColor,
          ),
        )
      : CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(valueColor ?? Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}