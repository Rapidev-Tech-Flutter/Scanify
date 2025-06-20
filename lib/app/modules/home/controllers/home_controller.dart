

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:open_file/open_file.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:scanify/app/modules/home/views/all_scans.dart';
import 'package:scanify/app/widgets/input_feild.dart';
import 'package:share_plus/share_plus.dart';

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
    savedFiles.sort((a, b) => b.dateSaved.compareTo(a.dateSaved));
    isLoading = false;
    update();
  }

   void onViewAllTap() {
    Get.to(() => AllScansView(fromViewAll: true));
  } 

  void onRefreshTap() async {
    isLoading = true;
    update();

    savedFiles = await HiveDatabase.syncScanifyFolderToHive();
    savedFiles.sort((a, b) => b.dateSaved.compareTo(a.dateSaved));
    isLoading = false;
    update();
  }

   onMultipleDeleteTap() async {
    final selectedFiles = savedFiles.where((e) => e.isChecked()).toList();
    if(selectedFiles.isEmpty) return;
    isLoading = true;
    update();
    await HiveDatabase.deleteSavedFilesByIds(selectedFiles.map((e) => e.id).toList());
    savedFiles.removeWhere((file) => selectedFiles.contains(file));
    isLoading = false;
    update();
  }

  onMultipleShareTap() async {
    final selectedFiles = savedFiles.where((e) => e.isChecked()).toList();
    if(selectedFiles.isEmpty) return;
    final params = ShareParams(
      text: 'Check out these documents I scanned using Scanify!',
      files: selectedFiles.map((e) => XFile(e.filePath)).toList(), 
    );

    final result = await SharePlus.instance.share(params);
   
    if (result.status == ShareResultStatus.success) {
      for (var e in selectedFiles) {
        e.isChecked.value = false;
      }
      debugPrint('Thank you for sharing the documents!');
    }
  }

   onSingleShareTap(SavedFileItem p1) async {
    final params = ShareParams(
      text: 'Check out this document I scanned using Scanify!',
      files: [XFile(p1.filePath)], 
    );

    final result = await SharePlus.instance.share(params);
    if (result.status == ShareResultStatus.success) {
        debugPrint('Thank you for sharing the picture!');
    }
  }

  onToWordTap() {
  }

  onViewTap(SavedFileItem p1) async{
    await OpenFile.open(p1.filePath);
  }

  onSingleDeleteTap(SavedFileItem p1) async {
    p1.isLoading.value = true;
    await HiveDatabase.deleteSavedFilesByIds([p1.id]);
    savedFiles.remove(p1);
    p1.isLoading.value = false;
    update();
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
          savedFiles.insert(0, file);
          update();
        }
      }
    
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  onOcrTap() {
  }

  onIdScanTap() {
    startScan();
  }

  onSingleScanTap() {
    startScan(pageLimit: 1);
  }

  final batchFieldController = TextEditingController();
  
  onBatchScanTap() async {
    final pageLimit = await Get.dialog(
      AlertDialog(
        title: Text('Batch Scan'),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Batch scan allows you to scan multiple pages at once.'),
            SizedBox(height: 16),
            InputField(hintText: 'Number of pages', inputController: batchFieldController,type: TextInputType.numberWithOptions(signed: false,decimal: false)),
            SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final count = int.tryParse(batchFieldController.text);
              Get.back(result: count);
            },
            child: Text('Proceed'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    if(pageLimit != null) {
      startScan(pageLimit: pageLimit);
    }
  }

}
