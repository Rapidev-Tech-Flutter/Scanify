import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:scanify/app/widgets/my_network_image.dart';

import '../controllers/import_images_controller.dart';

class ImportImagesView extends GetView<ImportImagesController> {
  const ImportImagesView({super.key});
  @override
  Widget build(BuildContext context) {
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
              itemCount: 10,
              shrinkWrap: true,  
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                return  MyNetworkImage(
                  height: itemWidth,
                  width: itemWidth,
                  fit: BoxFit.contain,
                  radius: 8,
                  imageUrl: '',
                );
              },
            );
          }
        ),
      ),
    );
  }
}
