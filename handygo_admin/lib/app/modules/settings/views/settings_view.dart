import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AdminColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AdminSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: AdminTextStyles.h1),
                const SizedBox(height: 4),
                Text(
                  'Configure platform settings and preferences',
                  style: AdminTextStyles.bodySmallSecondary,
                ),
                const SizedBox(height: AdminSpacing.xxl),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGroupCard(
                              controller,
                              'general',
                              'General',
                              Icons.tune_rounded,
                            ),
                          ),
                          const SizedBox(width: AdminSpacing.lg),
                          Expanded(
                            child: _buildGroupCard(
                              controller,
                              'notifications',
                              'Notifications',
                              Icons.notifications_none_rounded,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildGroupCard(
                          controller,
                          'general',
                          'General',
                          Icons.tune_rounded,
                        ),
                        const SizedBox(height: AdminSpacing.lg),
                        _buildGroupCard(
                          controller,
                          'notifications',
                          'Notifications',
                          Icons.notifications_none_rounded,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AdminSpacing.lg),
                _buildGroupCard(
                  controller,
                  'commission',
                  'Commission & Fees',
                  Icons.percent_rounded,
                ),
                const SizedBox(height: AdminSpacing.lg),
                _dangerZone(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGroupCard(
    SettingsController controller,
    String groupKey,
    String title,
    IconData icon,
  ) {
    final items = controller.settings[groupKey] ?? [];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminColors.primary, size: 20),
              const SizedBox(width: AdminSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.md),
          ...items.map((item) {
            if (item['value'] == '1' || item['value'] == '0') {
              return _toggleRow(
                (item['key'] as String).replaceAll('_', ' ').capitalizeFirst!,
                item['value'] == '1',
                (val) {
                  controller.updateSettings([
                    {'key': item['key'], 'value': val ? '1' : '0'},
                  ]);
                },
              );
            }
            return _settingRow(
              (item['key'] as String).replaceAll('_', ' ').capitalizeFirst!,
              item['value'].toString(),
              (newVal) {
                controller.updateSettings([
                  {'key': item['key'], 'value': newVal},
                ]);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _settingRow(String label, String value, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showEditDialog(label, value, onSave),
            borderRadius: BorderRadius.circular(AdminSpacing.xs),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AdminSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AdminColors.neutral100,
                borderRadius: BorderRadius.circular(AdminSpacing.xs),
                border: Border.all(
                  color: AdminColors.borderDark,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: AdminColors.primary,
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: isOn,
            activeThumbColor: AdminColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    String label,
    String value,
    Function(String) onSave,
  ) {
    final fieldCtrl = TextEditingController(text: value);
    Get.dialog(
      AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text(
          'Edit $label',
          style: const TextStyle(
            color: AdminColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: fieldCtrl,
          autofocus: true,
          style: const TextStyle(color: AdminColors.textPrimary),
          decoration: InputDecoration(
            hintText: label,
            fillColor: AdminColors.neutral100,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminSpacing.xs),
              borderSide: const BorderSide(color: AdminColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminSpacing.xs),
              borderSide: const BorderSide(color: AdminColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminSpacing.xs),
              borderSide: const BorderSide(
                color: AdminColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(fieldCtrl.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Danger zone ────────────────────────────────────────────────

  Widget _dangerZone() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AdminColors.danger,
                size: 20,
              ),
              const SizedBox(width: AdminSpacing.xs),
              Text(
                'Danger Zone',
                style: const TextStyle(
                  color: AdminColors.danger,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.md),
          _dangerRow(
            'Suspend All Workers',
            'Temporarily disable all worker accounts',
          ),
          _dangerRow('Clear Job History', 'Remove all completed job records'),
          _dangerRow('Reset Platform', 'Factory reset all platform data'),
        ],
      ),
    );
  }

  Widget _dangerRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.danger.withValues(alpha: 0.08),
              foregroundColor: AdminColors.danger,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Execute',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
