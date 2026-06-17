import 'package:get/get.dart';

import 'package:handygo_worker/app/modules/wallet/controllers/wallet_controller.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 3) {
      final walletController = Get.find<WalletController>();
      walletController.fetchBalance();
      walletController.fetchTransactions();
    }
  }
}
