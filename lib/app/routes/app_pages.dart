import 'package:get/get.dart';

import '../modules/custom_pdf_viewer/bindings/custom_pdf_viewer_binding.dart';
import '../modules/custom_pdf_viewer/views/custom_pdf_viewer_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/import_images/bindings/import_images_binding.dart';
import '../modules/import_images/views/import_images_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.IMPORT_IMAGES,
      page: () => const ImportImagesView(),
      binding: ImportImagesBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOM_PDF_VIEWER,
      page: () => const CustomPdfViewerView(),
      binding: CustomPdfViewerBinding(),
    ),
  ];
}
