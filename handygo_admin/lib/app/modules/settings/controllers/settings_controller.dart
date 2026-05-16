import 'package:get/get.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';

class SettingsController extends GetxController {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  
  var isLoading = true.obs;
  var settings = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      final response = await _api.get(AdminApiConstants.adminSettings);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final Map<String, dynamic> data = response.data['data'];
        settings.clear();
        data.forEach((group, items) {
          settings[group] = List<Map<String, dynamic>>.from(items);
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load settings', backgroundColor: AdminColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSettings(List<Map<String, dynamic>> updatedItems) async {
    try {
      final response = await _api.post(AdminApiConstants.adminSettings, data: {
        'settings': updatedItems.map((item) => {
          'key': item['key'],
          'value': item['value'].toString(),
        }).toList(),
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('Success', 'Settings updated successfully', backgroundColor: AdminColors.success, colorText: Colors.white);
        fetchSettings();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update settings', backgroundColor: AdminColors.error, colorText: Colors.white);
    }
  }
}
