import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = 'N45,500'.obs;
  var totalWithdrawn = 'N120,000'.obs;

  final transactions = <Map<String, String>>[
    {
      'title': 'Kitchen Plumbing',
      'date': 'Today, 2:00 PM',
      'amount': '+ N12,000',
      'status': 'Completed',
    },
    {
      'title': 'Withdrawal to GTBank',
      'date': 'Yesterday',
      'amount': '- N20,000',
      'status': 'Processed',
    },
    {
      'title': 'AC Service',
      'date': 'May 8, 2026',
      'amount': '+ N8,000',
      'status': 'Completed',
    },
  ].obs;

  void withdraw() {
    // Logic for bank transfer
  }
}
