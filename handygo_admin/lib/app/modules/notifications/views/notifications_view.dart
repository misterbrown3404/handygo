import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedTarget = 'all';
  bool _sendEmail = true;
  bool _isSending = false;

  Future<void> _sendBroadcast() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    try {
      final response = await _api.post(AdminApiConstants.broadcastNotifications, data: {
        'title': _titleController.text,
        'body': _bodyController.text,
        'target': _selectedTarget,
        'send_email': _sendEmail,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar('Success', 'Broadcast sent successfully', 
          backgroundColor: AdminColors.success, colorText: Colors.white);
        _titleController.clear();
        _bodyController.clear();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send broadcast');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), 
        backgroundColor: AdminColors.error, colorText: Colors.white);
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Send push notifications and broadcast messages to users', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 32),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildBroadcastForm()),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildNotificationTips()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBroadcastForm() {
    return GlassCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Broadcast Message', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            _label('Target Audience'),
            const SizedBox(height: 8),
            _buildTargetSelector(),
            const SizedBox(height: 16),
            
            SwitchListTile(
              value: _sendEmail,
              onChanged: (v) => setState(() => _sendEmail = v),
              title: const Text('Also send via Email', style: TextStyle(color: AdminColors.textPrimary, fontSize: 14)),
              subtitle: const Text('Sends a copy of this message to the users inbox', style: TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
              activeColor: AdminColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            
            _label('Notification Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: AdminColors.textPrimary),
              decoration: _inputDecoration('Enter a catchy title...'),
              validator: (v) => v!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 24),
            
            _label('Message Body'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bodyController,
              style: const TextStyle(color: AdminColors.textPrimary),
              maxLines: 5,
              decoration: _inputDecoration('What would you like to tell your users?'),
              validator: (v) => v!.isEmpty ? 'Message body is required' : null,
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendBroadcast,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSending 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Send Broadcast Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetSelector() {
    return Row(
      children: [
        _targetOption('All Users', 'all', Icons.groups_rounded),
        const SizedBox(width: 12),
        _targetOption('Workers Only', 'workers', Icons.engineering_rounded),
        const SizedBox(width: 12),
        _targetOption('Customers Only', 'customers', Icons.person_rounded),
      ],
    );
  }

  Widget _targetOption(String label, String value, IconData icon) {
    final isSelected = _selectedTarget == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTarget = value),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AdminColors.primary.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AdminColors.primary : AdminColors.borderDark),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AdminColors.primary : AdminColors.textSecondary),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: isSelected ? AdminColors.primary : AdminColors.textSecondary, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTips() {
    return Column(
      children: [
        _tipCard('Engagement Tip', 'Use concise titles and personalized messages to increase open rates.', Icons.lightbulb_outline_rounded, AdminColors.accent),
        const SizedBox(height: 16),
        _tipCard('Timing', 'Sending notifications between 9 AM and 11 AM usually gets the best engagement.', Icons.schedule_rounded, AdminColors.warning),
        const SizedBox(height: 16),
        _tipCard('Compliance', 'Ensure your messages follow platform guidelines to avoid being marked as spam.', Icons.gavel_rounded, AdminColors.error),
      ],
    );
  }

  Widget _tipCard(String title, String content, IconData icon, Color color) {
    return GlassCard(
      glowColor: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AdminColors.textSecondary, fontSize: 14),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AdminColors.borderDark.withValues(alpha: 0.5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AdminColors.borderDark.withValues(alpha: 0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.primary)),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
