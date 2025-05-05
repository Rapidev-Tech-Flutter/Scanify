import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanify/app/widgets/loading_pro.dart';


enum ImageType { file, asset, network }
class MyNetworkImage extends StatefulWidget {
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
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {
  ImageType imageType = ImageType.network;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
     if(widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      imageType = ImageType.asset;
      imageUrl = widget.errorImageUrl;
    }else {
      imageType = widget.imageType;
      imageUrl = widget.imageUrl;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Opacity(
      opacity: widget.opacity ?? 1,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.radius.r),
        child: imageType != ImageType.network ? SizedBox(
          height: widget.height?.h,
          width: widget.width?.w,
          child: imageType == ImageType.file ? Image.file(
            File(imageUrl??widget.errorImageUrl),
            height: widget.height?.h,
            width: widget.width?.w,
            fit: widget.fit,
          )  :  Image.asset(
              imageUrl ?? widget.errorImageUrl,
              height: widget.height?.h,
              width: widget.width?.w,
              fit: widget.fit,
            ),
          ) : CachedNetworkImage(
            imageUrl:imageUrl ?? widget.errorImageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: widget.height?.h,
              width: widget.width?.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: widget.fit,
                ),
              ),
            ),
            placeholder: (context, url) => SizedBox(
              height: widget.height?.h,
              width: widget.width?.h,
              child: Center(
                child: LoadingPro(
                  size: 20,
                  backgroundColor: Colors.transparent,
                  platFormIsIOS: true,
                ),
              ),
            ),
            errorWidget: (context, url, error) => widget.errorWidget ?? SizedBox(
              height: widget.height?.h,
              width: widget.width?.w,
              child: Image.asset( 
                widget.errorImageUrl,
                fit: widget.fit ?? BoxFit.cover,
                height: widget.height?.h,
                width: widget.width?.w,
              ),
            ),
        ),
      ),
    );
  }
}