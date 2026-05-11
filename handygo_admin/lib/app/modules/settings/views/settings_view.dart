import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
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
                      Expanded(child: _generalSettings()),
                      const SizedBox(width: 24),
                      Expanded(child: _notificationSettings()),
                    ],
                  );
                }
                return Column(children: [_generalSettings(), const SizedBox(height: 24), _notificationSettings()]);
              },
            ),
            const SizedBox(height: 24),
            _commissionSettings(),
            const SizedBox(height: 24),
            _dangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _generalSettings() {
    return _settingsCard('General', Icons.tune_rounded, [
      _settingRow('Platform Name', 'HandyGo', Icons.business_rounded),
      _settingRow('Default Currency', 'NGN (₦)', Icons.currency_exchange_rounded),
      _settingRow('Timezone', 'WAT (UTC+1)', Icons.access_time_rounded),
      _settingRow('Default Language', 'English', Icons.language_rounded),
    ]);
  }

  Widget _notificationSettings() {
    return _settingsCard('Notifications', Icons.notifications_none_rounded, [
      _toggleRow('Email Notifications', true),
      _toggleRow('SMS Alerts', true),
      _toggleRow('Push Notifications', false),
      _toggleRow('Weekly Reports', true),
    ]);
  }

  Widget _commissionSettings() {
    return _settingsCard('Commission & Fees', Icons.percent_rounded, [
      _settingRow('Platform Commission', '15%', Icons.percent_rounded),
      _settingRow('Min Withdrawal', '₦5,000', Icons.account_balance_wallet_rounded),
      _settingRow('Transaction Fee', '₦100', Icons.receipt_long_rounded),
      _settingRow('KYC Fee', 'Free', Icons.verified_user_rounded),
    ]);
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AdminColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AdminColors.error.withOpacity(0.3)),
            ),
            child: const Text('Execute', style: TextStyle(color: AdminColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(String title, IconData headerIcon, List<Widget> children) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon, color: AdminColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _settingRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AdminColors.textSecondary, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AdminColors.borderDark.withOpacity(0.5)),
            ),
            child: Text(value, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(String label, bool isOn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14))),
          Switch(value: isOn, activeColor: AdminColors.primary, onChanged: (val) {}),
        ],
      ),
    );
  }
}
