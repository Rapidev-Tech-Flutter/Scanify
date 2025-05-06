// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';

import 'package:scanify/app/modules/home/views/home_view.dart';
import 'package:scanify/app/modules/import_images/views/import_images_view.dart';
import 'package:uuid/uuid.dart';

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
          pageLimit: 10,
        ),
      );
      result = await _documentScanner?.scanDocument();
      debugPrint('result: $result');
      if(result != null && result!.pdf != null) {
        log('here ====> ');
        final pdf = result!.pdf!;
        saveFileToScanifyFolder(pdf.uri);
      }
      update();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> saveFileToScanifyFolder(String sourcePath) async {
   
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      log("❌ Source file doesn't exist: $sourcePath");
      return;
    }

    final fileName = 'scanfiy-document-${DateTime.now().toIso8601String()}';
    final fileExt = sourceFile.uri.pathSegments.last.split('.').last;
    final mimeType = MimeType.values.firstWhereOrNull((e) => e.type  == (lookupMimeType(sourcePath) ?? 'application/octet-stream')) ?? MimeType.other;
    final fileBytes = await sourceFile.readAsBytes();

    if (Platform.isAndroid) {
      // Ask for storage permission
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        final path = await FileSaver.instance.saveAs(
          name: fileName,
          bytes: fileBytes,
          ext: fileExt,
          mimeType: mimeType,
          filePath: 'Scanify' 
        );

        if(path != null) {
          log("✅ File saved to Downloads on Android $path");
          HiveDatabase.addSavedFile(SavedFileItem(
            id: Uuid().v4(), 
            fileName: fileName, 
            filePath: path, 
            dateSaved: DateTime.now()
          ));
        }
       
        return;
      }

      log("❌ Android storage permission denied");
    
    } else if (Platform.isIOS) {
      path_provider.getLibraryDirectory();
      final directory = await path_provider.getApplicationDocumentsDirectory();
      final savePath = "${directory.path}/$fileName";
      final savedFile = await File(savePath).writeAsBytes(fileBytes);
      log("✅ File saved to iOS Documents: ${savedFile.path}");
    } else {
      log("❌ Unsupported platform");
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
