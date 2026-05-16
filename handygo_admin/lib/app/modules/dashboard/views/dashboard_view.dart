import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/stat_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/modules/analytics/widgets/charts.dart';
import 'package:handygo_admin/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AdminColors.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.error.value,
                  style: const TextStyle(color: AdminColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchDashboard,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDashboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(controller),
                const SizedBox(height: 32),
                _statsRow(controller),
                const SizedBox(height: 32),
                _chartsRow(controller),
                const SizedBox(height: 32),
                _bottomSection(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _header(DashboardController c) {
    final now = DateFormat('MMMM yyyy').format(DateTime.now());
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Welcome back, Admin. Here\'s your platform overview.',
              style: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AdminColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    now,
                    style: const TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: c.fetchDashboard,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AdminColors.primary, AdminColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AdminColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsRow(DashboardController c) {
    final formatter = NumberFormat('#,###');
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.0,
          children: [
            StatCard(
              title: 'Total Revenue',
              value: '₦${formatter.format(c.totalRevenue.value)}',
              change: '${c.activeSubscriptions.value} active subs',
              icon: Icons.payments_rounded,
              color: AdminColors.primary,
            ),
            StatCard(
              title: 'Active Workers',
              value: '${c.activeWorkers.value}',
              change: '${c.totalWorkers.value} total',
              icon: Icons.engineering_rounded,
              color: AdminColors.accent,
            ),
            StatCard(
              title: 'Total Customers',
              value: '${c.totalCustomers.value}',
              change: 'Registered',
              icon: Icons.people_rounded,
              color: AdminColors.warning,
            ),
            StatCard(
              title: 'Pending KYC',
              value: '${c.pendingKyc.value}',
              change: 'Needs review',
              icon: Icons.verified_user_rounded,
              color: AdminColors.chart4,
            ),
          ],
        );
      },
    );
  }

  Widget _chartsRow(DashboardController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: RevenueChart(data: c.revenueChart)),
              const SizedBox(width: 24),
              Expanded(child: JobCategoryChart(data: c.workersByCategory)),
            ],
          );
        }
        return Column(
          children: [
            RevenueChart(data: c.revenueChart),
            const SizedBox(height: 24),
            JobCategoryChart(data: c.workersByCategory),
          ],
        );
      },
    );
  }

  Widget _bottomSection(DashboardController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: WeeklyJobsChart(data: []),
              ), // No weekly volume on dashboard yet
              const SizedBox(width: 24),
              Expanded(child: _recentActivity(c)),
            ],
          );
        }
        return Column(
          children: [
            const WeeklyJobsChart(data: []),
            const SizedBox(height: 24),
            _recentActivity(c),
          ],
        );
      },
    );
  }

  Widget _recentActivity(DashboardController c) {
    final activities = c.recentActivity;
    if (activities.isEmpty) {
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    color: AdminColors.textSecondary.withValues(alpha: 0.4),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No recent activity',
                    style: TextStyle(color: AdminColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map((a) {
            final type = a['type'] ?? 'worker';
            IconData icon;
            Color color;
            switch (type) {
              case 'subscription':
                icon = Icons.payment_rounded;
                color = AdminColors.primary;
                break;
              case 'kyc':
                icon = Icons.verified_user_rounded;
                color = AdminColors.warning;
                break;
              default:
                icon = Icons.person_add_rounded;
                color = AdminColors.accent;
            }
            return _activityItem(
              a['title'] ?? '',
              a['sub'] ?? '',
              a['time'] ?? '',
              icon,
              color,
            );
          }),
        ],
      ),
    );
  }

  Widget _activityItem(
    String title,
    String sub,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: AdminColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
