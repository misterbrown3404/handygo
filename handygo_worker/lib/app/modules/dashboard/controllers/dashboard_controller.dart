import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isOnline = true.obs;
  var totalEarnings = 'N45,500'.obs;
  var jobsDone = '12'.obs;

  void toggleOnline(bool value) {
    isOnline.value = value;
  }
}
