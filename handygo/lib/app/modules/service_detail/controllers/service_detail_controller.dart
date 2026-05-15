import 'package:get/get.dart';
import 'package:handygo/app/data/models/service_model.dart';

class ServiceDetailController extends GetxController {
  final service = Rxn<ServiceModel>();
  final rating = 5.obs;
  final tipAmount = 50.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ServiceModel) {
      service.value = Get.arguments;
    }
  }

  void setRating(int value) {
    rating.value = value;
  }
}
