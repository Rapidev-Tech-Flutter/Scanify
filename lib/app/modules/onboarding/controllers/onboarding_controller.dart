import 'package:get/get.dart';
import 'package:scanify/app/routes/app_pages.dart';

class OnboardingController extends GetxController {

  int currentIndex = 1;

  List<Map<String,dynamic>> obData = [
    {
      'title': 'Begin Your\nScanning Journey',
      'subtitle': 'Easily turn your documents into digital files with Scanify',
      'image': 'assets/images/ob-1.png',
    },
    {
      'title': 'Simple Way To\nScan',
      'subtitle': 'Scan documents quickly and easily with Scanify',
      'image': 'assets/images/ob-2.png',
    },
    {
      'title': 'Stay Organized\nWith Ease',
      'subtitle': 'Effortlessly organize your scans in one place with Scanify',
      'image': 'assets/images/ob-3.png',
    },
    {
      'title': 'Your Data, Safely\nSecured',
      'subtitle': 'Keep your scanned documents protected with top-notch security',
      'image': 'assets/images/ob-4.png',
    },
  ];
  
  onNextTap() {
    if(currentIndex < (obData.length -1)){
      currentIndex++;
    } else {
      Get.toNamed(Routes.HOME);
    }
  }


  void onSkipPressed() {
  }
}
