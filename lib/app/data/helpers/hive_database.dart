

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';
import 'package:uuid/uuid.dart';


class HiveDatabase {
  HiveDatabase._();

  static final saveFilesBox = Hive.box<SavedFileItem>('saved_files');

  static Future<void> deleteSavedFileById(String id) async {
    // Find the item with the matching id
    final keyToDelete = saveFilesBox.keys.cast<int>().firstWhere(
      (key) => saveFilesBox.get(key)?.id == id,
      orElse: () => -1,
    );

    if (keyToDelete != -1) {
      await saveFilesBox.delete(keyToDelete);
      debugPrint("✅ Deleted file with id: $id");
    } else {
      debugPrint("❌ No file found with id: $id");
    }
  }

  static Future<void> addSavedFile(SavedFileItem file) async {
    await saveFilesBox.add(file);
  }

  static Future<List<SavedFileItem>> getAllSavedFiles() async {
    for (int i = 0; i < saveFilesBox.length; i++) {
        final key = saveFilesBox.keyAt(i);
        await checkFileExists(key);
    }

    return saveFilesBox.values.toList();
  }

  static checkFileExists(key) async {
  
    final item = saveFilesBox.get(key);

    if (item != null) {
      final file = File(item.filePath);
      final exists = await file.exists();

      if (!exists && !item.isRemoved) {
        final updatedItem = SavedFileItem(
          id: item.id,
          fileName: item.fileName,
          filePath: item.filePath,
          dateSaved: item.dateSaved,
          isRemoved: true,
        );
        await saveFilesBox.put(key, updatedItem);
      } else if (exists && item.isRemoved) {
        final updatedItem = SavedFileItem(
          id: item.id,
          fileName: item.fileName,
          filePath: item.filePath,
          dateSaved: item.dateSaved,
          isRemoved: false,
        );
        await saveFilesBox.put(key, updatedItem);
      }
    }
  }

  static Future<List<SavedFileItem>>  syncScanifyFolderToHive() async {
    final directory = Directory('/storage/emulated/0/Download/Scanify'); // Adjust path if needed
    
    if (!await directory.exists()) return saveFilesBox.values.toList();

    final filesInDirectory = directory
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.pdf')) // Filter for specific file types
        .toList();

    final existingItems = saveFilesBox.values.toList();
     for (int i = 0; i < saveFilesBox.length; i++) {
        final key = saveFilesBox.keyAt(i);
        await checkFileExists(key);
    }

    final existingFileNames = existingItems.map((e) => e.fileName.toLowerCase()).toSet();

    for (final file in filesInDirectory) {
      final fileName = file.uri.pathSegments.last.split('.').first.toLowerCase();
      if (!existingFileNames.contains(fileName)) {
        final newItem = SavedFileItem(
          id: Uuid().v4(),
          fileName: fileName,
          filePath: file.path,
          dateSaved: DateTime.now(),
        );
        await saveFilesBox.add(newItem);
      }
    }

    // Return updated list from Hive
    return saveFilesBox.values.toList();
  }

  static Future<SavedFileItem?> saveFileToScanifyFolder({String? sourcePath, Uint8List? bytes}) async {
    String fileName;
    String fileExt;
    Uint8List? fileBytes;
    MimeType mimeType = MimeType.other;
    final id = Uuid().v4();
    if(sourcePath != null){
      final sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        log("❌ Source file doesn't exist: $sourcePath");
        return null;
      }

      fileName = 'scanify-document-$id';
      fileExt = sourceFile.uri.pathSegments.last.split('.').last;
      mimeType = MimeType.values.firstWhereOrNull((e) => e.type  == (lookupMimeType(sourcePath) ?? 'application/octet-stream')) ?? MimeType.other;
      fileBytes = await sourceFile.readAsBytes();
    } else {
      fileName = 'Scanify/scanify-document-$id';
      fileExt = 'pdf';
      mimeType = MimeType.pdf;
      fileBytes = bytes;
    }

    if(fileBytes == null) return null;
   

    String? savedPath;
        
    if (Platform.isAndroid) {
      // Ask for storage permission
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        final fileSaver = FileSaver.instance;

        savedPath = await fileSaver.saveAs(
          name: fileName,
          bytes: fileBytes,
          ext: fileExt,
          mimeType: mimeType,
          filePath: 'Scanify',
        );
      } else {
        log("❌ Android storage permission denied");
      }


    
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