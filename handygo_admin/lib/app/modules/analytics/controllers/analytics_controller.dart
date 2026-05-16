import 'package:get/get.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class AnalyticsController extends GetxController {
  final AdminApiClient _api = Get.find<AdminApiClient>();

  final isLoading = true.obs;
  final error = ''.obs;

  // KPI Stats
  final kpis = <String, dynamic>{}.obs;

  // Charts
  final revenueData = <Map<String, dynamic>>[].obs;
  final jobsByCategory = <Map<String, dynamic>>[].obs;
  final weeklyVolume = <Map<String, dynamic>>[].obs;

  // Top workers
  final topWorkers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Overview / KPI
      final overResp = await _api.get(AdminApiConstants.analyticsOverview);
      if (overResp.statusCode == 200 && overResp.data['success'] == true) {
        kpis.value = Map<String, dynamic>.from(overResp.data['data']);
      }

      // Revenue
      final revResp = await _api.get(AdminApiConstants.analyticsRevenue);
      if (revResp.statusCode == 200 && revResp.data['success'] == true) {
        revenueData.assignAll(List<Map<String, dynamic>>.from(revResp.data['data']));
      }

      // Jobs by category
      final catResp = await _api.get(AdminApiConstants.analyticsJobsByCategory);
      if (catResp.statusCode == 200 && catResp.data['success'] == true) {
        jobsByCategory.assignAll(List<Map<String, dynamic>>.from(catResp.data['data']));
      }

      // Weekly volume
      final volResp = await _api.get(AdminApiConstants.analyticsWeeklyVolume);
      if (volResp.statusCode == 200 && volResp.data['success'] == true) {
        weeklyVolume.assignAll(List<Map<String, dynamic>>.from(volResp.data['data']));
      }

      // Top workers
      final topResp = await _api.get(AdminApiConstants.analyticsTopWorkers);
      if (topResp.statusCode == 200 && topResp.data['success'] == true) {
        topWorkers.assignAll(List<Map<String, dynamic>>.from(topResp.data['data']));
      }
    } catch (e) {
      error.value = 'Failed to load analytics data';
      print('Analytics fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
