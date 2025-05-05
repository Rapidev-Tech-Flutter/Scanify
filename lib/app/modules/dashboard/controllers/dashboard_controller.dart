import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scanify/app/modules/home/views/home_view.dart';
import 'package:scanify/app/modules/import_images/views/import_images_view.dart';

class DashboardController extends GetxController {
  int currentIndex = 0;

  List<Widget> pages = [
    HomeView(),
    ImportImagesView(),
  ];
 
  void onNavItemTap(int value) {
    currentIndex = value;
    update();
  }

  void scanTap() {
  }
}
