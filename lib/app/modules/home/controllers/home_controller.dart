
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';

class HomeController extends GetxController {

  List<SavedFileItem> savedFiles = [];

  final searchController = TextEditingController();

  bool isLoading = true;

  @override
  onInit() {
    super.onInit();
    getList();
  }

  getList() async {
    savedFiles = await HiveDatabase.getAllSavedFiles();
    isLoading = false;
    update();
  }

  onViewTap() {
  }

  onToWordTap() {
  }

  onShareTap() {
  }

  DocumentScanner? _documentScanner;

  void startScan({DocumentFormat format = DocumentFormat.pdf,int pageLimit = 2}) async {
    try {
      DocumentScanningResult? result;
      _documentScanner?.close();

      _documentScanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormat: format,
          mode: ScannerMode.full,
          isGalleryImport: false,
          pageLimit: pageLimit,
        ),
      );
      
      result = await _documentScanner?.scanDocument();
      
      debugPrint('result: $result');
      
      if(result != null && result.pdf != null) {
        final pdf = result.pdf!;
        final file = await HiveDatabase.saveFileToScanifyFolder(sourcePath: pdf.uri);
        if(file != null)  {
          savedFiles.add(file);
          update();
        }
      }
    
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  onBatchTap() {
  }

  onsScanTap() {
    startScan(pageLimit: 5);
  }

  onIdScanTap() {
    startScan();
  }

  onOcrTap() {
  }

  void onRefreshTap() async {
    isLoading = true;
    update();

    savedFiles = await HiveDatabase.syncScanifyFolderToHive();
    isLoading = false;
    update();
  }
}
