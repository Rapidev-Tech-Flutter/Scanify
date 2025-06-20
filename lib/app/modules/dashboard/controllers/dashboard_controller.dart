// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/modules/home/controllers/home_controller.dart';

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
    startScan(DocumentFormat.pdf);
  }

  DocumentScanner? _documentScanner;
  DocumentScanningResult? result;

  @override
  onClose() {
    _documentScanner?.close();
    super.onClose();
  }

  void startScan(DocumentFormat format) async {
    try {
      result = null;
      update();
      _documentScanner?.close();
      _documentScanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormat: format,
          mode: ScannerMode.full,
          isGalleryImport: false,
          pageLimit: 1,
        ),
      );
      result = await _documentScanner?.scanDocument();
      if(result != null && result!.pdf != null) {
        final pdf = result!.pdf!;
        final file = await HiveDatabase.saveFileToScanifyFolder(sourcePath: pdf.uri);
        if(file != null) {
          if(Get.isRegistered<HomeController>()){
            final HomeController controller = Get.find<HomeController>();
            controller.savedFiles.insert(0, file);
            controller.update();
          }
          
        }
      }
      update();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  
}

class FileItem {
  String id;
  String title;
  String path;
  DateTime createdAt;
  FileItem({
    required this.id,
    required this.title,
    required this.path,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'path': path,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory FileItem.fromMap(Map<String, dynamic> map) {
    return FileItem(
      id: map['id'] as String,
      title: map['title'] as String,
      path: map['path'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FileItem.fromJson(String source) => FileItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
