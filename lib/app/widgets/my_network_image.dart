import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanify/app/widgets/loading_pro.dart';


enum ImageType { file, asset, network }
class MyNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String errorImageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final ImageType imageType;
  final BorderRadius? borderRadius;
  final double radius;
  final double? opacity;
  final Widget? errorWidget;
  const MyNetworkImage({
    super.key, 
    this.imageUrl, 
    this.height, 
    this.width,
    this.radius = 0, 
    this.errorImageUrl = 'assets/images/dummy.jpg',
    this.fit = BoxFit.cover, 
    this.borderRadius, 
    this.opacity, 
    this.errorWidget, 
    this.imageType = ImageType.network,
  });

  @override
  Widget build(BuildContext context) {
    return  Opacity(
      opacity: opacity ?? 1,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius.r),
        child: imageType != ImageType.network ? SizedBox(
          height: height?.h,
          width: width?.w,
          child: imageType == ImageType.file ? Image.file(
            File(imageUrl??errorImageUrl),
            height: height?.h,
            width: width?.w,
            fit: fit,
          )  :  Image.asset(
              imageUrl ?? errorImageUrl,
              height: height?.h,
              width: width?.w,
              fit: fit,
            ),
          ) : CachedNetworkImage(
            imageUrl: imageUrl ?? errorImageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: height?.h,
              width: width?.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => SizedBox(
              height: height?.h,
              width: width?.h,
              child: Center(
                child: LoadingPro(
                  size: 20,
                  backgroundColor: Colors.transparent,
                  platFormIsIOS: true,
                ),
              ),
            ),
            errorWidget: (context, url, error) => errorWidget ?? SizedBox(
              height: height?.h,
              width: width?.w,
              child: Image.asset( 
                errorImageUrl,
                fit: fit ?? BoxFit.cover,
                height: height?.h,
                width: width?.w,
              ),
            ),
        ),
      ),
    );
  }
}