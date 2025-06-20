import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scanify/app/modules/home/controllers/home_controller.dart';
import 'package:scanify/app/modules/home/views/widgets/file_item_widget.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/input_feild.dart';

class AllScansView extends GetView<HomeController> {
  final bool fromViewAll;
  const AllScansView({super.key, this.fromViewAll = false});

  @override
  Widget build(BuildContext context) {
    return fromViewAll ? GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            shadowColor: Clr.transparent,
            scrolledUnderElevation: 0,
            title: Text('All Scans', 
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
          body: buildView(),
        );
      }
    ) : buildView();
  }

  buildView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InputField(
                  prefixIconData: Icons.search,
                  hintText: 'Search your file', 
                  inputController: controller.searchController,
                  onChanged: (p0) => controller.update(),
                ),
              ),
              if(controller.savedFiles.isEmpty) buildActionButtons()
              else Obx(() {
                if(controller.savedFiles.any((e) => e.isChecked())){
                  return Row(
                    children: [
                      SizedBox(width: 46.w),
                      GestureDetector(
                        onTap: controller.onMultipleDeleteTap,
                        child: Icon(
                          CupertinoIcons.delete,
                          color: Colors.red,
                        ),
                      ).paddingOnly(right: 29.w),
                      GestureDetector(
                        onTap: controller.onMultipleShareTap,
                        child: Icon(CupertinoIcons.share, color: Clr.primary),
                      ),
                    ],
                  );
                } else {
                  return buildActionButtons();
                }
              }),
              
              
             
            ]
          ).paddingSymmetric(vertical: 24.h),
          if(!fromViewAll) Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Scans',
                style:  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              GestureDetector(
                onTap: controller.onViewAllTap,
                child: Row(
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
                ),
              )
            ],
          ).paddingOnly(bottom: 8.h),
          buildListView(),
        ],
      ),
    );
  }

  buildActionButtons() {
    return Row(
      children:[
        SizedBox(width: 46.w),
        SvgPicture.asset(AssetPath.addFileIcon).paddingOnly(right: 29.w),
        GestureDetector(
          onTap: controller.onRefreshTap,
          child: SvgPicture.asset(AssetPath.refreshIcon),
        ),
      ],
    );
  }

  buildListView() {
    final files = controller.searchController.text.isNotEmpty 
      ? controller.savedFiles.where((file) => file.fileName.toLowerCase().contains(controller.searchController.text.toLowerCase())).toList()
      : controller.savedFiles;
    return Expanded(
      child: controller.isLoading ? loader : files.isEmpty ? Center(
        child: Text(
          controller.searchController.text.isNotEmpty  ? 'No search results' : 'No files found',
        ),
      ) : ListView.builder(
        itemCount: files.length < 10 || fromViewAll ? files.length : 10,
        padding: EdgeInsets.zero,
        itemBuilder: (context,index) {
          final file = files[index];
          return FileItemWidget(
            file: file,
            onShareTap: controller.onSingleShareTap,
            onToWordTap: controller.onToWordTap,
            onViewTap: controller.onViewTap,
            onDeleteTap: controller.onSingleDeleteTap,
          );
        }, 
      )
    );
  }
}