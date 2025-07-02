

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:scanify/app/modules/home/views/all_scans.dart';
import 'package:scanify/app/static/constants.dart';
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

  onOcrTap() async {
    ImageSource? source = await Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OCR'),
            IconButton(onPressed: Get.back, icon: Icon(Icons.close))
          ],
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediaDialogButton(
                  title: 'Camera',
                  icon: Icons.camera,
                  onTap: () async {
                     Get.back(result: ImageSource.camera);
                  },
                ),
                SizedBox(width: 20.w),
                MediaDialogButton(
                  title: 'Gallery',
                  icon: Icons.image,
                  onTap: () async {
                    Get.back(result: ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
    if(source == null) return;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile == null) return;

    final path = pickedFile.path;
    final inputImage = InputImage.fromFilePath(path);

    var textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    final ocrText = recognizedText.text;
    final TextEditingController controller = TextEditingController(
      text: ocrText,
    );
    await Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OCR'),
            IconButton(onPressed: Get.back, icon: Icon(Icons.close))
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              readOnly: true,
              
              maxLines: 10,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
            },
            child: Text('Select All'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: controller.text));
            },
            child: Text('Copy'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Batch Scan'),
            IconButton(onPressed: Get.back, icon: Icon(Icons.close))
          ],
        ),
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

class MediaDialogButton extends StatelessWidget {
  const MediaDialogButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Clr.primary, width: 2.w),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: IconButton(
            splashColor: Clr.transparent,
            focusColor: Clr.transparent,
            hoverColor: Clr.transparent,
            highlightColor: Clr.transparent,
            onPressed: onTap,
            icon: Icon(
              icon,
              color: Clr.primary,
              size: 25.h,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(title.tr, style: TextStyle(color: Clr.primary, fontSize: 16.sp))
      ],
    );
  }
}