import 'package:get/get.dart';

import '../controllers/custom_pdf_viewer_controller.dart';

class CustomPdfViewerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomPdfViewerController>(
      () => CustomPdfViewerController(),
    );
  }
}
