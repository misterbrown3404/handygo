import 'package:get/get.dart';
import 'package:handygo_worker/app/data/models/job_request_model.dart';

class BookingsController extends GetxController {
  final requests = <JobRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRequests();
  }

  void _loadRequests() {
    requests.assignAll([
      JobRequestModel(
        id: '1',
        customerName: 'Sarah Williams',
        serviceType: 'AC Maintenance',
        location: 'Victoria Island, Lagos',
        distance: 2.4,
        price: 'N8,000',
        dateTime: DateTime.now(),
      ),
      JobRequestModel(
        id: '2',
        customerName: 'Michael Chen',
        serviceType: 'Plumbing Repair',
        location: 'Lekki Phase 1',
        distance: 5.1,
        price: 'N15,000',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
      ),
    ]);
  }
}
