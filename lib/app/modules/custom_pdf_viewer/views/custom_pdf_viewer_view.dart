import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/custom_pdf_viewer_controller.dart';

class CustomPdfViewerView extends GetView<CustomPdfViewerController> {

  const CustomPdfViewerView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomPdfViewerController>(
      init: CustomPdfViewerController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('CustomPdfViewerView'),
            centerTitle: true,
          ),
          body:  SfPdfViewer.memory(controller.pdfData!)
        );
      }
    );
  }
}
