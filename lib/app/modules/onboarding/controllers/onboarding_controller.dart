import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scanify/app/routes/app_pages.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {

  int currentIndex = 0;

  List<Map<String,dynamic>> obData = [
    {
      'title': 'Begin Your\nScanning Journey',
      'subtitle': 'Easily turn your documents into digital files with Scanify',
      'image': AssetPath.Onboarding1,
    },
    {
      'title': 'Simple Way To\nScan',
      'subtitle': 'Scan documents quickly and easily with Scanify',
      'image': AssetPath.Onboarding2,
    },
    {
      'title': 'Stay Organized\nWith Ease',
      'subtitle': 'Effortlessly organize your scans in one place with Scanify',
      'image': AssetPath.Onboarding3,
    },
    {
      'title': 'Your Data, Safely\nSecured',
      'subtitle': 'Keep your scanned documents protected with top-notch security',
      'image': AssetPath.Onboarding4,
    },
  ];

  PageController pageController = PageController();
  
  onNextTap() async {
    if(currentIndex < (obData.length -1)){
      currentIndex++;
      update();
      pageController.nextPage(duration: 500.milliseconds, curve: Curves.ease);
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('onboardingDone', true);
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }


  void onSkipPressed() {
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
