import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  T? read<T>(String key) => Get.find<GetStorage>().read<T>(key);
  Future<void> write(String key, dynamic value) => Get.find<GetStorage>().write(key, value);
  Future<void> remove(String key) => Get.find<GetStorage>().remove(key);
}
