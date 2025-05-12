import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/input_feild.dart';
import 'package:scanify/app/widgets/my_network_image.dart';
import 'package:scanify/app/widgets/submit_button.dart';
import 'package:intl/intl.dart';

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
                  buildIconButton(title: 'Single Scan',icon: AssetPath.sScanIcon,onTap: controller.onsScanTap),
                  buildIconButton(title: 'Batch Mode',icon: AssetPath.batchIcon,onTap: controller.onBatchTap),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        prefixIconData: Icons.search,
                        hintText: 'Search your file', 
                        inputController: TextEditingController(),
                      ),
                    ),
                    SizedBox(width: 46.w),
                    SvgPicture.asset(AssetPath.addFileIcon),
                    SizedBox(width: 29.w),
                    SvgPicture.asset(AssetPath.refreshIcon),
            
                  ]
                ).paddingSymmetric(vertical: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Scans',
                      style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      children: [
                         Text(
                          'View All',
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    )
                  ],
                ).paddingOnly(bottom: 8.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.savedFiles.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context,index) {
                      final file = controller.savedFiles[index];
                      return FileItemWidget(
                        imageUrl: '', 
                        title: file.fileName, 
                        subtitle: DateFormat('yyyy-MM-dd HH:mm').format(file.dateSaved), 
                        isChecked: false.obs, 
                        isExpanded: false.obs,
                        onShareTap: controller.onShareTap,
                        onToWordTap: controller.onToWordTap,
                        onViewTap: controller.onViewTap,
                      );
                    }, 
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }

  buildIconButton({required String title,required String icon,Function()? onTap}) {
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

class FileItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final RxBool isChecked;
  final Function(bool?)? onCheckChanged;
  final RxBool isExpanded;
  final Function()? onShareTap;
  final Function()? onToWordTap;
  final Function()? onViewTap;
  const FileItemWidget({
    super.key, 
    required this.imageUrl, 
    required this.title, 
    required this.subtitle, 
    required this.isChecked,
    this.onCheckChanged, 
    required this.isExpanded, 
    this.onShareTap, 
    this.onToWordTap, 
    this.onViewTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isExpanded.toggle();
      },
      child: Column(
        children: [
          Row(
            children: [
               MyNetworkImage(
                height: 66.86,
                width: 72,
                fit: BoxFit.contain,
                radius: 8,
                imageUrl: imageUrl,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: Clr.subtextColor
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(width: 16.w),
              Obx(() => Checkbox.adaptive(
                  value: isChecked.value, 
                  onChanged: onCheckChanged,
                  side: BorderSide(
                    color: Clr.subtextColor,
                    width: 1.4
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)
                  ),
                ),
              )
            ],
          ),
          Obx(() => !isExpanded() ? SizedBox.shrink() : Column(
              children: [
                Row(
                  children: [
                    SubmitButton(
                      height: 32,
                      width: 96,
                      bgColor: Clr.inputfieldColor,
                      textColor: Clr.textColor,
                      fontWeight: FontWeight.w400,
                      textSize: 14,
                      title: 'Share', 
                    ),
                    SubmitButton(
                      height: 32,
                      width: 96,
                      bgColor: Clr.inputfieldColor,
                      textColor: Clr.textColor,
                      fontWeight: FontWeight.w400,
                      textSize: 14,
                      title: 'To Word', 
                    ).paddingSymmetric(horizontal: 20.w),
                    SubmitButton(
                      height: 32,
                      width: 96,
                      bgColor: Clr.inputfieldColor,
                      textColor: Clr.textColor,
                      fontWeight: FontWeight.w400,
                      textSize: 14,
                      title: 'View', 
                    ),
                    
                  ],
                ).paddingSymmetric(vertical: 20.h),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Color(0xFFD9D9D9),
                )
              ],
            ),
          )
        ],
      ).paddingSymmetric(vertical: 12.07),
    );
  }
}