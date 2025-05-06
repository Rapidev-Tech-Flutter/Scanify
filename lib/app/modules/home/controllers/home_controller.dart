import 'package:get/get.dart';
import 'package:scanify/app/data/helpers/hive_database.dart';
import 'package:scanify/app/data/models/saved_file_item.dart';

class HomeController extends GetxController {

  List<SavedFileItem> savedFiles = [];
  @override
  onInit() {
    super.onInit();
    getList();
  }

  getList() async {
    savedFiles = await HiveDatabase.getAllSavedFiles();
    update();
  }

  onViewTap() {
  }

  onToWordTap() {
  }

  onShareTap() {
  }
}
