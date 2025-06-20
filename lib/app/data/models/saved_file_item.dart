import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

part 'saved_file_item.g.dart';

@HiveType(typeId: 0)
class SavedFileItem extends HiveObject {
  
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final DateTime dateSaved;
  
  @HiveField(4)
  bool isRemoved; 

  Rx<bool> isChecked = false.obs;
  Rx<bool> isExpanded = false.obs;
  Rx<bool> isLoading = false.obs;


  SavedFileItem({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.dateSaved,
    this.isRemoved = false,
  });
}