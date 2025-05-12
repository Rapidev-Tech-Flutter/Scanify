

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:uuid/uuid.dart';


class HiveDatabase {
  HiveDatabase._();

  static Future<void> deleteSavedFileById(String id) async {
    final box = Hive.box<SavedFileItem>('saved_files');

    // Find the item with the matching id
    final keyToDelete = box.keys.cast<int>().firstWhere(
      (key) => box.get(key)?.id == id,
      orElse: () => -1,
    );

    if (keyToDelete != -1) {
      await box.delete(keyToDelete);
      print("✅ Deleted file with id: $id");
    } else {
      print("❌ No file found with id: $id");
    }
  }

  static Future<void> addSavedFile(SavedFileItem file) async {
    final box = Hive.box<SavedFileItem>('saved_files');
    await box.add(file);
  }

  static Future<List<SavedFileItem>> getAllSavedFiles() async {
    final box = Hive.box<SavedFileItem>('saved_files');
    return box.values.toList();
  }

  static Future<SavedFileItem?> saveFileToScanifyFolder({String? sourcePath, Uint8List? bytes}) async {
    String fileName;
    String fileExt;
    Uint8List? fileBytes;
    MimeType mimeType = MimeType.other;
    if(sourcePath != null){
      final sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        log("❌ Source file doesn't exist: $sourcePath");
        return null;
      }

      fileName = 'scanfiy-document-${DateTime.now().toIso8601String()}';
      fileExt = sourceFile.uri.pathSegments.last.split('.').last;
      mimeType = MimeType.values.firstWhereOrNull((e) => e.type  == (lookupMimeType(sourcePath) ?? 'application/octet-stream')) ?? MimeType.other;
      fileBytes =await sourceFile.readAsBytes();
    } else {
      fileName = 'scanfiy-document-${DateTime.now().toIso8601String()}';
      fileExt = 'pdf';
      mimeType = MimeType.pdf;
      fileBytes = bytes;
    }

    if(fileBytes == null) return null;
   

    String? savedPath;
        
    if (Platform.isAndroid) {
      // Ask for storage permission
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        savedPath = await FileSaver.instance.saveAs(
          name: fileName,
          bytes: fileBytes,
          ext: fileExt,
          mimeType: mimeType,
          filePath: 'Scanify' 
        );
      }

      log("❌ Android storage permission denied");
    
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      savedPath = "${directory.path}/$fileName";
      try {
        await File(savedPath).writeAsBytes(fileBytes);
      } catch (e) {
        return null;
      }
    } 

    SavedFileItem? file;
    if(savedPath != null) {
      file = SavedFileItem(
        id: Uuid().v4(), 
        fileName: File(savedPath).uri.pathSegments.last.split('.').first, 
        filePath: savedPath, 
        dateSaved: DateTime.now()
      );
      log("✅ File saved to $savedPath");
      HiveDatabase.addSavedFile(file);
    }

    return file;
  }
}