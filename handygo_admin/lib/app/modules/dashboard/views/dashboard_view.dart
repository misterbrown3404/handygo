import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
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
        // Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AdminColors.primary),
          );
        }

        // Error
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AdminSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AdminSpacing.lg),
                    decoration: BoxDecoration(
                      color: AdminColors.dangerLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AdminColors.danger,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.lg),
                  Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: AdminTextStyles.bodyWith(AdminColors.textSecondary),
                  ),
                  const SizedBox(height: AdminSpacing.lg),
                  ElevatedButton(
                    onPressed: controller.fetchDashboard,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDashboard,
          color: AdminColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AdminSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(controller),
                const SizedBox(height: AdminSpacing.xxl),
                _statsRow(controller),
                const SizedBox(height: AdminSpacing.xxl),
                _chartsRow(controller),
                const SizedBox(height: AdminSpacing.xxl),
                _bottomSection(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Page header ────────────────────────────────────────────────

  Widget _header(DashboardController c) {
    final now = DateFormat('MMMM yyyy').format(DateTime.now());
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 600;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: AdminTextStyles.h1),
                  const SizedBox(height: 2),
                  Text(
                    "Welcome back, Admin. Here's your platform overview.",
                    style: AdminTextStyles.bodySmallSecondary,
                  ),
                ],
              ),
            ),
            if (wide) const SizedBox(width: AdminSpacing.lg),
            Wrap(
              spacing: AdminSpacing.sm,
              runSpacing: AdminSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AdminSpacing.sm,
                    vertical: AdminSpacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: AdminColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: AdminSpacing.xs),
                      Text(
                        now,
                        style: AdminTextStyles.bodySmallSecondary,
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AdminColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: c.fetchDashboard,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(AdminSpacing.sm),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: AdminColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Stat cards ─────────────────────────────────────────────────

  Widget _statsRow(DashboardController c) {
    final formatter = NumberFormat('#,###');
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop: 2×2 grid, Tablet: 2-cols, Phone: 1-col
        final isTablet = constraints.maxWidth >= 800;
        return GridView.count(
          crossAxisCount: isTablet ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AdminSpacing.lg,
          mainAxisSpacing: AdminSpacing.lg,
          childAspectRatio: 1.8,
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

  // ── Revenue + Pie charts ───────────────────────────────────────

  Widget _chartsRow(DashboardController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: RevenueChart(data: c.revenueChart)),
              const SizedBox(width: AdminSpacing.lg),
              Expanded(flex: 2, child: JobCategoryChart(data: c.workersByCategory)),
            ],
          );
        }
        return Column(
          children: [
            RevenueChart(data: c.revenueChart),
            const SizedBox(height: AdminSpacing.lg),
            JobCategoryChart(data: c.workersByCategory),
          ],
        );
      },
    );
  }

  // ── Weekly jobs + Recent activity ─────────────────────────────

  Widget _bottomSection(DashboardController c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: WeeklyJobsChart(data: []),
              ),
              const SizedBox(width: AdminSpacing.lg),
              Expanded(child: _recentActivity(c)),
            ],
          );
        }
        return Column(
          children: [
            const WeeklyJobsChart(data: []),
            const SizedBox(height: AdminSpacing.lg),
            _recentActivity(c),
          ],
        );
      },
    );
  }

  // ── Recent activity list ───────────────────────────────────────

  Widget _recentActivity(DashboardController c) {
    final activities = c.recentActivity;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: AdminColors.accent,
                size: 18,
              ),
              const SizedBox(width: AdminSpacing.xs),
              Text('Recent Activity', style: AdminTextStyles.h3),
            ],
          ),
          const SizedBox(height: AdminSpacing.lg),
          if (activities.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    color: AdminColors.textSecondary.withValues(alpha: 0.3),
                    size: 48,
                  ),
                  const SizedBox(height: AdminSpacing.sm),
                  Text(
                    'No recent activity',
                    style: AdminTextStyles.bodySmallSecondary,
                  ),
                ],
              ),
            )
          else
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
            padding: const EdgeInsets.all(AdminSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: AdminSpacing.sm),
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
