

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:scanify/app/routes/app_pages.dart';
import 'package:scanify/app/static/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.manageExternalStorage.request();

  await Hive.initFlutter();
  Hive.registerAdapter(SavedFileItemAdapter());

  await Hive.openBox<SavedFileItem>('saved_files');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
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
            fontFamily: 'Poppins',
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
