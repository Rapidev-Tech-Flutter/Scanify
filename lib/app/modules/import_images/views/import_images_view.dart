import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/my_network_image.dart';
import 'package:scanify/app/widgets/submit_button.dart';

import '../controllers/import_images_controller.dart';

class ImportImagesView extends GetView<ImportImagesController> {
  const ImportImagesView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImportImagesController>(
      init: ImportImagesController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title:  Text(
              'Select Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            leading: Icon(Icons.close),
            actions: [
              if(controller.assets.isNotEmpty) Obx(() => controller.assets.any((e) => e.isSelected()) ? SubmitButton(
                  title: 'Import (${controller.assets.where((e) => e.isSelected()).length})',
                  width: 96.w,
                  height: 32.h,
                  bgColor: Clr.white,
                  textColor: Clr.textColor,
                  padding: EdgeInsets.zero,
                  textSize: 14,
                  fontWeight: FontWeight.w400,
                  onTap: controller.onImportTap,
                ).paddingOnly(right: 16.w) : SizedBox.shrink(),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxItemSize = 72;
                double crossSpacing = 16;
                double mainSpacing = 16;
                      
                // Calculate the max number of items that can fit in a row
                int crossAxisCount = ((constraints.maxWidth + crossSpacing) /  (maxItemSize + crossSpacing)).floor();
                      
                // Adjust item width to distribute space evenly
                double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * crossSpacing) / crossAxisCount;
                      
                double childAspectRatio = itemWidth / itemWidth;
            
                return GridView.builder(
                  itemCount: controller.assets.length,
                  shrinkWrap: true,  
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: mainSpacing,
                    crossAxisSpacing: crossSpacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                     final asset = controller.assets[index];
                    return   FutureBuilder(
                        future: asset.asset.thumbnailData.then((value) => value!),
                        builder: (_, snapshot) {
                          final bytes = snapshot.data;
                        return Stack(
                          children: [
                            MyNetworkImage(
                              height: itemWidth,
                              width: itemWidth,
                              fit: BoxFit.cover,
                              radius: 8,
                              imageBtyes: bytes,
                              imageType: ImageType.memory,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Obx(() => Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: asset.isSelected.value, 
                                onChanged: (bool? value) {
                                  asset.isSelected.value = value ?? false;
                                }
                              )),
                            )
                          ],
                        );
                      }
                    );
                  },
                );
              }
            ),
          ),
        );
      }
    );
  }
}
 