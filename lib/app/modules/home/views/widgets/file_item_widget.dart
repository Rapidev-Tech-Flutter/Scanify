import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:scanify/app/widgets/my_network_image.dart';
import 'package:scanify/app/widgets/submit_button.dart';

class FileItemWidget extends StatelessWidget {
  final SavedFileItem file;
  final Function(bool?)? onCheckChanged;
  final Function(SavedFileItem)? onShareTap;
  final Function()? onToWordTap;
  final Function(SavedFileItem)? onViewTap;
  final Function(SavedFileItem)? onDeleteTap;
  const FileItemWidget({
    super.key, 
    required this.file,
    this.onCheckChanged, 
    this.onShareTap, 
    this.onToWordTap, 
    this.onViewTap, this.onDeleteTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: file.isRemoved ? null : file.isExpanded.toggle,
      child: Column(
        children: [
          Row(
            children: [
               MyNetworkImage(
                height: 66.86,
                width: 72,
                fit: BoxFit.contain,
                radius: 8,
                imageUrl: '',
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: file.isRemoved ? Clr.subtextColor : Clr.textColor,
                        decoration: file.isRemoved ? TextDecoration.lineThrough : TextDecoration.none, 
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(file.dateSaved),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: Clr.subtextColor,
                        decoration: file.isRemoved ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(width: 16.w),
              if(!file.isRemoved) Obx(() => Checkbox.adaptive(
                value: file.isChecked.value, 
                onChanged: onCheckChanged ?? (value) {
                  file.isChecked.value = value ?? false;
                },
                side: BorderSide(
                  color: Clr.subtextColor,
                  width: 1.4
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r)
                ),
              )) else Obx(() => file.isLoading() ? loader :  GestureDetector(
                onTap: onDeleteTap == null ? null : () => onDeleteTap!(file),
                child: Icon(
                  Icons.delete,
                  color: Clr.subtextColor,
                ),
              )),
              
            ],
          ),
          if(!file.isRemoved) Obx(() => !file.isExpanded() ? SizedBox.shrink() : Column(
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
                      onTap: onShareTap == null ? null : () => onShareTap!(file),
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
                      onTap: onViewTap == null ? null : () => onViewTap!(file),
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