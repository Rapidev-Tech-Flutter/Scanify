import 'package:get/get.dart';

import '../controllers/import_images_controller.dart';

class ImportImagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportImagesController>(
      () => ImportImagesController(),
    );
  }
}
