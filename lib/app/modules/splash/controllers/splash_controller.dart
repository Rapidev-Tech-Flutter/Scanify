import 'package:get/get.dart';
import 'package:scanify/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SplashController extends GetxController  {
  SplashController();


  @override
  void onInit() {
    super.onInit();
    Future.delayed(2.seconds,() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboardingDone') ?? false;
      if(onboardingDone){
        // TODO: NAVIGATE TO DASHBOARD ONCE DESIGN IS DONE
        Get.offAndToNamed(Routes.ONBOARDING);
      }else {
        Get.offAndToNamed(Routes.ONBOARDING);
      }
    });
  }

}