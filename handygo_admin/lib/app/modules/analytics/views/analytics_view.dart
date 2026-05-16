import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/modules/analytics/controllers/analytics_controller.dart';
import 'package:handygo_admin/app/modules/analytics/widgets/charts.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
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
                  onPressed: controller.fetchAnalytics,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(controller),
              const SizedBox(height: 32),
              _kpiRow(controller),
              const SizedBox(height: 32),
              RevenueChart(data: controller.revenueData),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WeeklyJobsChart(data: controller.weeklyVolume),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: JobCategoryChart(
                            data: controller.jobsByCategory,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      WeeklyJobsChart(data: controller.weeklyVolume),
                      const SizedBox(height: 24),
                      JobCategoryChart(data: controller.jobsByCategory),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              _topWorkersSection(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _header(AnalyticsController controller) {
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
              'Analytics & Reports',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Deep insights into platform performance and growth',
              style: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: controller.fetchAnalytics,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh Data'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kpiRow(AnalyticsController controller) {
    final kpis = controller.kpis;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final items = [
          _kpiCard(
            'Avg. Job Value',
            '₦${kpis['avg_job_value'] ?? '0'}',
            '+5.2%',
            Icons.trending_up_rounded,
          ),
          _kpiCard(
            'Worker Retention',
            '${kpis['worker_retention'] ?? '0'}%',
            '+2.1%',
            Icons.people_rounded,
          ),
          _kpiCard(
            'Active Subscriptions',
            '${kpis['active_subscriptions'] ?? '0'}',
            '+12%',
            Icons.card_membership_rounded,
          ),
          _kpiCard(
            'Jobs This Month',
            '${kpis['jobs_this_month'] ?? '0'}',
            '-0.5%',
            Icons.task_alt_rounded,
          ),
        ];
        if (isWide) {
          return Row(
            children: items
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: e,
                    ),
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: e,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _kpiCard(String title, String value, String change, IconData icon) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AdminColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: AdminColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topWorkersSection(AnalyticsController controller) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: AdminColors.warning,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Top Performing Workers',
                style: TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.topWorkers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No data available',
                  style: TextStyle(color: AdminColors.textSecondary),
                ),
              ),
            ),
          ...controller.topWorkers.asMap().entries.map((entry) {
            final index = entry.key;
            final w = entry.value;
            final rank = index + 1;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AdminColors.borderDark.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: rank == 1
                          ? AdminColors.warning.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '#$rank',
                        style: TextStyle(
                          color: rank == 1
                              ? AdminColors.warning
                              : AdminColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AdminColors.primary.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      w['name']?[0] ?? '?',
                      style: const TextStyle(
                        color: AdminColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w['name'] ?? 'Unknown',
                          style: const TextStyle(
                            color: AdminColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          w['specialty'] ?? 'N/A',
                          style: const TextStyle(
                            color: AdminColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _miniInfo(
                    Icons.task_alt_rounded,
                    '${w['jobs_count'] ?? 0} jobs',
                  ),
                  const SizedBox(width: 24),
                  _miniInfo(Icons.star_rounded, '${w['rating'] ?? 0.0}'),
                  const SizedBox(width: 24),
                  Text(
                    '₦${w['earnings'] ?? 0}',
                    style: const TextStyle(
                      color: AdminColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AdminColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AdminColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
