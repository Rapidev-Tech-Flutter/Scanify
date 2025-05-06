

import 'package:hive/hive.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';


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
}