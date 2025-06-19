import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' as pm;

import 'package:scanify/app/routes/app_pages.dart';
import 'package:scanify/app/static/custom_dailog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scanify/main.dart';

class ImportImagesController extends GetxController {

  List<AssetModel> assets = [];

  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    callInit();
  }

  callInit() async{
    assets = await requestAssets();

    isLoading = false;
    update();
  }

  Future<List<AssetModel>> requestAssets() async {
    pm.PermissionState permissionState = await pm.PhotoManager.getPermissionState(requestOption: pm.PermissionRequestOption(
      androidPermission: pm.AndroidPermission(
        type: pm.RequestType.image, 
        mediaLocation: true
      ),
      iosAccessLevel: pm.IosAccessLevel.readWrite
    ));
    
    if(permissionState == pm.PermissionState.authorized || permissionState == pm.PermissionState.limited) {
      // Once permissions are granted, load media.
      final assetsResponse = await pm.PhotoManager.getAssetListRange(
        start: 0,
        end: 100000,
        type: pm.RequestType.image,
      );

      return assetsResponse.map((e) => AssetModel(asset: e, type: e.type)).toList();
    } else {
      buildCustomDialog(
        title: 'Permission Required'.tr,
        desc: 'Please allow "Photos" access.'.tr,
        okayBtnText: 'Go to Setting',
        barrierDismissible: false,
        isEqualFlex: false,
        onOk: () {
          Get.back();
          Get.back();
          openAppSettings();
        },
        cancelBtnText: 'back'
      );
      return [];
    }
  }

  onImportTap() async {
    final selectedPics = assets.where((e) => e.isSelected()).toList();
    
    final pdf = await createPdf(selectedPics.map((e) => e.asset).toList());

    if(pdf == null) return;    
 
    for (var e in selectedPics) {
      e.isSelected.value = false;
    }

    Get.toNamed(Routes.CUSTOM_PDF_VIEWER, arguments: {
      'pdf': pdf,
    });
  }

  Future<Uint8List?> createPdf(List<pm.AssetEntity> list) async {
    final doc = pw.Document();
    final logoImage = await loadAssetImage('assets/images/app_logo.png');   
    int i = 0;

    // //Create a new PDF document.
    // final sfd.PdfDocument document = sfd.PdfDocument();
    // //Read image data.
   
    

    //  await Future.wait(list.map((item) async {
    //   final bytes = await item.thumbnailData;
    //   i += 1;
    //   log('Done => $i ${item.height.h} ${item.width.w} ${PdfPageFormat.a4.height} ${PdfPageFormat.a4.width}');
    //   if(bytes == null) {
    //     return pw.SizedBox.shrink();
    //   }

    //   final height = item.height.h > PdfPageFormat.a4.height ? PdfPageFormat.a4.height : item.height.h;
    //   final width = item.width.w > PdfPageFormat.a4.width ? PdfPageFormat.a4.width : item.width.w;

    //   final Uint8List imageData = bytes;
    //   //Load the image using PdfBitmap.
    //   final sfd.PdfBitmap image = sfd.PdfBitmap(imageData);
    //   //Draw the image to the PDF page.
    //   document.pageSettings.size = Size(width, height); 
    //   document.pageSettings.margins = (sfd.PdfMargins()..all = 0);

    //   sfd.PdfPage page = document.pages.add();
    //   page.graphics
    //       .drawImage(image, Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height));
    // }));
    
    // // Save the document.
    // final listOfInts = await document.save();

    // Uint8List pdfBytes = Uint8List.fromList(listOfInts);
    // document.dispose();
    
    // return pdfBytes;

    // await Future.wait(list.map((item) async {
    //   final bytes = await item.thumbnailData;
    //   i += 1;
    //   log('Done => $i ${item.height.h} ${item.width.w} ${PdfPageFormat.a4.height} ${PdfPageFormat.a4.width}');
    //   if(bytes == null) {
    //     return pw.SizedBox.shrink();
    //   }

    //   final height = item.height.h;// > PdfPageFormat.a4.height ? PdfPageFormat.a4.height : item.height.h;
    //   final width = 1.sw;

    //   log("$height $width");
      
    //   final page = pw.Container(
    //     height: height,
    //     width: width,
    //     // margin: pw.EdgeInsets.symmetric(vertical: 20,horizontal: 32),
    //     decoration: pw.BoxDecoration(
    //       image: pw.DecorationImage(
    //         image: pw.MemoryImage(bytes),
    //         fit: pw.BoxFit.scaleDown,
    //       ),
    //     ),
    //   );
    //   doc.addPage(
    //     pw.Page(
          
    //       pageFormat: PdfPageFormat(width,height),
    //       build: (pw.Context context) => page
    //     ),
    //   );
    // }));
       
    List<pw.Widget> sectionWidgetList = [];
    sectionWidgetList.addAll([
      ...await Future.wait(list.map((item) async {
        final bytes = await item.thumbnailData;
        i += 1;
        log('Done => $i ${item.height.h} ${item.width.w} ${PdfPageFormat.a4.height} ${PdfPageFormat.a4.width}');
        if(bytes == null) {
          return pw.SizedBox.shrink();
        }

        final height = item.height.h > PdfPageFormat.a4.height ? PdfPageFormat.a4.height : item.height.h;
        final width = item.width.w > PdfPageFormat.a4.width ? PdfPageFormat.a4.width : item.width.w;

        log("$height $width");
        
        return pw.Container(
          height: height,
          width: width,
          margin: pw.EdgeInsets.symmetric(vertical: 20),
          decoration: pw.BoxDecoration(
            image: pw.DecorationImage(
              image: pw.MemoryImage(bytes),
              fit: pw.BoxFit.cover,
            ),
          ),
        );
      })),
      
    ]);
    
    doc.addPage(
      pw.MultiPage(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a3,
        maxPages: 500,
        margin: pw.EdgeInsets.symmetric(vertical: 20.w, horizontal: 65.w),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(
                logoImage,
                height: 30.h,
                width: 30.w,
                fit: pw.BoxFit.contain,
              ),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(font: customFont, color: PdfColors.grey),
          );
        },
        build: (pw.Context context) => sectionWidgetList,
      ),
    );

    return await doc.save();
  }

  Future<pw.ImageProvider> loadAssetImage(String path) async {
    final imageBytes = await rootBundle.load(path);
    final buffer = imageBytes.buffer;
    return pw.MemoryImage(buffer.asUint8List());
  }
}

class AssetModel{
  final pm.AssetEntity asset;
  final pm.AssetType type;
  RxBool isSelected = false.obs;
  RxBool isUploading = false.obs;

  AssetModel({required this.asset,required this.type});
}