import 'package:get/get.dart';
import 'package:scanify/app/routes/app_pages.dart';




class SplashController extends GetxController  {
  SplashController();


  @override
  void onInit() {
    super.onInit();
    Future.delayed(2.seconds,() {
      Get.toNamed(Routes.ONBOARDING);
    });
  }

}