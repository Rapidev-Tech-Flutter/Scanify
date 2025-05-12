import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:scanify/app/routes/app_pages.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Font? customFont;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.manageExternalStorage.request();
  await PhotoManager.requestPermissionExtend(requestOption: PermissionRequestOption(androidPermission: AndroidPermission(type: RequestType.image, mediaLocation: true)));


  await Hive.initFlutter();
  Hive.registerAdapter(SavedFileItemAdapter());

  await Hive.openBox<SavedFileItem>('saved_files');

 
  customFont = await loadCustomFont(); // Load the custom font here
  // await addIsArchiveToAllDocuments();
  runApp(const MyApp());
}

Future<pw.Font> loadCustomFont() async {
  try {
    final fontData = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
    return pw.Font.ttf(fontData.buffer.asByteData());
  } catch (e) {
    // Handle the error, possibly by loading a default font or notifying the user
    debugPrint('Error loading font: $e');
    // You can return a default font or rethrow the error based on your use case
    rethrow;
  }
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
