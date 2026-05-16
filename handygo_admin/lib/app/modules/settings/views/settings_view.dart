import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AdminColors.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Settings', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Configure platform settings and preferences', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 32),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildGroupCard(controller, 'general', 'General', Icons.tune_rounded)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildGroupCard(controller, 'notifications', 'Notifications', Icons.notifications_none_rounded)),
                      ],
                    );
                  }
                  return Column(children: [
                    _buildGroupCard(controller, 'general', 'General', Icons.tune_rounded), 
                    const SizedBox(height: 24), 
                    _buildGroupCard(controller, 'notifications', 'Notifications', Icons.notifications_none_rounded)
                  ]);
                },
              ),
              const SizedBox(height: 24),
              _buildGroupCard(controller, 'commission', 'Commission & Fees', Icons.percent_rounded),
              const SizedBox(height: 24),
              _dangerZone(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGroupCard(SettingsController controller, String groupKey, String title, IconData icon) {
    final items = controller.settings[groupKey] ?? [];
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map((item) {
            if (item['value'] == '1' || item['value'] == '0') {
              return _toggleRow((item['key'] as String).replaceAll('_', ' ').capitalizeFirst!, item['value'] == '1', (val) {
                controller.updateSettings([{'key': item['key'], 'value': val ? '1' : '0'}]);
              });
            }
            return _settingRow((item['key'] as String).replaceAll('_', ' ').capitalizeFirst!, item['value'], (newVal) {
              controller.updateSettings([{'key': item['key'], 'value': newVal}]);
            });
          }).toList(),
        ],
      ),
    );
  }

  Widget _settingRow(String label, String value, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14))),
          InkWell(
            onTap: () => _showEditDialog(label, value, onSave),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AdminColors.borderDark.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_rounded, size: 14, color: AdminColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(String label, bool isOn, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14))),
          Switch(value: isOn, activeColor: AdminColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }

  void _showEditDialog(String label, String value, Function(String) onSave) {
    final controller = TextEditingController(text: value);
    Get.dialog(
      AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('Edit $label', style: const TextStyle(color: AdminColors.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AdminColors.textPrimary),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _dangerZone() {
    return GlassCard(
      glowColor: AdminColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AdminColors.error, size: 20),
              SizedBox(width: 8),
              Text('Danger Zone', style: TextStyle(color: AdminColors.error, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _dangerRow('Suspend All Workers', 'Temporarily disable all worker accounts'),
          _dangerRow('Clear Job History', 'Remove all completed job records'),
          _dangerRow('Reset Platform', 'Factory reset all platform data'),
        ],
      ),
    );
  }

  Widget _dangerRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.error.withValues(alpha: 0.1), foregroundColor: AdminColors.error, elevation: 0),
            child: const Text('Execute', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
