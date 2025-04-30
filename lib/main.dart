import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:scanify/app/static/constants.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 812),
      builder: (context, child) {
        return GetMaterialApp(
          title: "Scanify",
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Clr.primary,
              elevation: .5,
              foregroundColor: Clr.white,
              iconTheme: IconThemeData(color: Clr.white),
            ),
            primaryColor: Clr.primary,
            scaffoldBackgroundColor: Clr.white,
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: Clr.primary),
          ),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
