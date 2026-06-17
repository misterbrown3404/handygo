import 'dart:async';

import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../../data/models/worker_model.dart';
import '../../../data/repositories/services_repository.dart';
import '../../../data/repositories/worker_repository.dart';

class MainController extends GetxController {
  final _servicesRepo = ServicesRepository();
  final _workerRepo = WorkerRepository();

  var selectedIndex = 0.obs;

  // Services State
  final services = <ServiceModel>[].obs;
  final workers = <WorkerModel>[].obs;
  final categories = <String>[].obs;
  final isLoadingServices = false.obs;
  final isLoadingWorkers = false.obs;
  final workersError = RxnString();
  final servicesError = "".obs;
  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
    fetchWorkers();
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void onSearchChanged(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      fetchWorkers(search: query.isEmpty ? null : query);
    });
  }

  Future<void> fetchServices() async {
    try {
      isLoadingServices(true);
      servicesError("");
      final data = await _servicesRepo.getServices();
      services.assignAll(data);
      _extractCategories();
    } catch (e) {
      servicesError("Failed to fetch services. Please try again.");
      print("Error fetching services: $e");
    } finally {
      isLoadingServices(false);
    }
  }

  Future<void> fetchWorkers({String? location, String? search}) async {
    try {
      isLoadingWorkers(true);
      workersError(null);
      final data = await _workerRepo.getWorkers(
        location: location,
        search: search,
      );
      workers.assignAll(data);
    } catch (e) {
      workersError.value = "Failed to fetch workers. Please try again.";
      print("Error fetching workers: $e");
    } finally {
      isLoadingWorkers(false);
    }
  }

  void _extractCategories() {
    final Set<String> cats = {};
    for (var service in services) {
      if (service.category != null) {
        cats.add(service.category!);
      }
    }
    categories.assignAll(cats.toList());
  }
}
