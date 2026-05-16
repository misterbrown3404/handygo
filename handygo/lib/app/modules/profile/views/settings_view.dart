import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/profile/controllers/profile_controller.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text("Settings", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("Notifications"),
          _buildToggleItem("Push Notifications", true),
          _buildToggleItem("Email Notifications", false),
          _buildToggleItem("SMS Notifications", true),

          const SizedBox(height: 32),
          _buildSectionHeader("Security"),
          _buildMenuItem("Change Password", Icons.lock_outline, () {}),
          _buildMenuItem(
            "Two-Factor Authentication",
            Icons.security_outlined,
            () {},
          ),

          const SizedBox(height: 32),
          _buildSectionHeader("General"),
          _buildMenuItem(
            "Language",
            Icons.language_outlined,
            () {},
            trailing: "English (US)",
          ),
          _buildMenuItem("Privacy Policy", Icons.privacy_tip_outlined, () {}),
          _buildMenuItem("Terms of Service", Icons.description_outlined, () {}),

          const SizedBox(height: 32),
          _buildMenuItem(
            "Logout",
            Icons.logout,
            () => controller.logout(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: (val) {},
            activeThumbColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    String? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.grey[700],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
