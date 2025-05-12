import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomPdfViewerController extends GetxController {

  Uint8List? pdfData;
  String fileName = '';
  // KSForm? form;
  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> data = Get.arguments;
    fileName = data['fileName'] ?? '';
    pdfData = data['pdf'];

    if(pdfData == null) {
      Get.back();
      return;
    }
  }

 
}
