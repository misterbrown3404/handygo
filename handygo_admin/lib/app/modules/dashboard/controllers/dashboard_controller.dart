import 'package:get/get.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class DashboardController extends GetxController {
  final AdminApiClient _api = Get.find<AdminApiClient>();

  final isLoading = true.obs;
  final error = ''.obs;

  // Stats
  final totalRevenue = 0.0.obs;
  final monthlyRevenue = 0.0.obs;
  final activeWorkers = 0.obs;
  final totalWorkers = 0.obs;
  final totalCustomers = 0.obs;
  final totalJobs = 0.obs;
  final activeSubscriptions = 0.obs;
  final expiredSubscriptions = 0.obs;
  final pendingKyc = 0.obs;

  // Recent activity
  final recentActivity = <Map<String, dynamic>>[].obs;

  // Revenue chart data
  final revenueChart = <Map<String, dynamic>>[].obs;

  // Workers by category
  final workersByCategory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _api.get(AdminApiConstants.dashboardStats);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        totalRevenue.value = (data['total_revenue'] ?? 0).toDouble();
        monthlyRevenue.value = (data['monthly_revenue'] ?? 0).toDouble();
        activeWorkers.value = data['active_workers'] ?? 0;
        totalWorkers.value = data['total_workers'] ?? 0;
        totalCustomers.value = data['total_customers'] ?? 0;
        totalJobs.value = data['total_jobs'] ?? 0;
        activeSubscriptions.value = data['active_subscriptions'] ?? 0;
        expiredSubscriptions.value = data['expired_subscriptions'] ?? 0;
        pendingKyc.value = data['pending_kyc'] ?? 0;

        if (data['recent_activity'] != null) {
          recentActivity.assignAll(List<Map<String, dynamic>>.from(data['recent_activity']));
        }
      }

      // Fetch revenue chart
      final revResp = await _api.get(AdminApiConstants.dashboardRevenue);
      if (revResp.statusCode == 200 && revResp.data['success'] == true) {
        revenueChart.assignAll(List<Map<String, dynamic>>.from(revResp.data['data']));
      }

      // Fetch workers by category
      final catResp = await _api.get(AdminApiConstants.workersByCategory);
      if (catResp.statusCode == 200 && catResp.data['success'] == true) {
        workersByCategory.assignAll(List<Map<String, dynamic>>.from(catResp.data['data']));
      }
    } catch (e) {
      error.value = 'Failed to load dashboard data';
      print('Dashboard fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
