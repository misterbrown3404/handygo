import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
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
      final response = await _api.post(
        AdminApiConstants.broadcastNotifications,
        data: {
          'title': _titleController.text,
          'body': _bodyController.text,
          'target': _selectedTarget,
          'send_email': _sendEmail,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.snackbar(
          'Success',
          'Broadcast sent successfully',
          backgroundColor: AdminColors.accent,
          colorText: AdminColors.white,
        );
        _titleController.clear();
        _bodyController.clear();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send broadcast');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AdminColors.danger,
        colorText: AdminColors.white,
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AdminSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.notifications_rounded,
                    color: AdminColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: AdminSpacing.xs),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Send push notifications and broadcast messages to users',
                style: AdminTextStyles.bodySmallSecondary,
              ),
              const SizedBox(height: AdminSpacing.xxl),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Main content spans full width — tip cards live below.
                ],
              ),
              const SizedBox(height: AdminSpacing.xl),

              // ── Broadcast form ──────────────────────────────────
              GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.campaign_rounded,
                            color: AdminColors.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text('New Broadcast Message', style: AdminTextStyles.h3),
                        ],
                      ),
                      const SizedBox(height: AdminSpacing.lg),

                      _label('Target Audience'),
                      const SizedBox(height: AdminSpacing.xs),
                      _buildTargetSelector(),
                      const SizedBox(height: AdminSpacing.md),

                      SwitchListTile(
                        value: _sendEmail,
                        onChanged: (v) => setState(() => _sendEmail = v),
                        title: Text(
                          'Also send via Email',
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text(
                          'Sends a copy of this message to the user\'s inbox',
                          style: TextStyle(
                            color: AdminColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        activeThumbColor: AdminColors.primary,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AdminSpacing.md),

                      _label('Notification Title'),
                      const SizedBox(height: AdminSpacing.xs),
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(color: AdminColors.textPrimary),
                        decoration: _inputDecoration(
                          'Enter a catchy title...',
                        ),
                        validator: (v) => v!.isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: AdminSpacing.md),

                      _label('Message Body'),
                      const SizedBox(height: AdminSpacing.xs),
                      TextFormField(
                        controller: _bodyController,
                        style: const TextStyle(color: AdminColors.textPrimary),
                        maxLines: 5,
                        decoration: _inputDecoration(
                          'What would you like to tell your users?',
                        ),
                        validator: (v) => v!.isEmpty ? 'Message body is required' : null,
                      ),
                      const SizedBox(height: AdminSpacing.lg),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSending ? null : _sendBroadcast,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminColors.primary,
                          ),
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AdminColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Send Broadcast Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AdminSpacing.lg),

              // ── Tips column ────────────────────────────────────
              Column(
                children: [
                  _tipCard(
                    'Engagement Tip',
                    'Use concise titles and personalized messages to increase open rates.',
                    Icons.lightbulb_outline_rounded,
                    AdminColors.accent,
                  ),
                  const SizedBox(height: AdminSpacing.sm),
                  _tipCard(
                    'Timing',
                    'Sending notifications between 9 AM and 11 AM usually gets the best engagement.',
                    Icons.schedule_rounded,
                    AdminColors.warning,
                  ),
                  const SizedBox(height: AdminSpacing.sm),
                  _tipCard(
                    'Compliance',
                    'Ensure your messages follow platform guidelines to avoid being marked as spam.',
                    Icons.gavel_rounded,
                    AdminColors.danger,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Target selector: wrapped flex ─────────────────────────────

  Widget _buildTargetSelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Row(
            children: [
              _targetOption('All Users', 'all', Icons.groups_rounded),
              const SizedBox(width: AdminSpacing.xs),
              _targetOption('Workers Only', 'workers', Icons.engineering_rounded),
              const SizedBox(width: AdminSpacing.xs),
              _targetOption('Customers Only', 'customers', Icons.person_rounded),
            ],
          );
        }
        return Column(
          children: [
            _targetOption('All Users', 'all', Icons.groups_rounded),
            const SizedBox(height: AdminSpacing.xs),
            _targetOption('Workers Only', 'workers', Icons.engineering_rounded),
            const SizedBox(height: AdminSpacing.xs),
            _targetOption('Customers Only', 'customers', Icons.person_rounded),
          ],
        );
      },
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
          padding: const EdgeInsets.symmetric(
            vertical: AdminSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AdminColors.primaryLight
                : AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AdminColors.primary
                  : AdminColors.borderDark,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AdminColors.primary
                    : AdminColors.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AdminColors.primary
                      : AdminColors.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tipCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: AdminSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AdminColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AdminColors.textSecondary,
        fontSize: 14,
      ),
      filled: true,
      fillColor: AdminColors.neutral100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AdminColors.borderDark.withValues(alpha: 0.5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AdminColors.borderDark.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AdminColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
