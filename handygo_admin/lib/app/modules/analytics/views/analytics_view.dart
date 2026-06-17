import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
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
          return const Center(
            child: CircularProgressIndicator(color: AdminColors.primary),
          );
        }

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
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.sm),
                  Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: AdminTextStyles.bodyWith(
                      AdminColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.sm),
                  ElevatedButton(
                    onPressed: controller.fetchAnalytics,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AdminSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(controller),
                const SizedBox(height: AdminSpacing.xxl),
                _kpiRow(controller),
                const SizedBox(height: AdminSpacing.xxl),
                RevenueChart(data: controller.revenueData),
                const SizedBox(height: AdminSpacing.xxl),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: WeeklyJobsChart(
                              data: controller.weeklyVolume,
                            ),
                          ),
                          const SizedBox(width: AdminSpacing.lg),
                          Expanded(
                            flex: 2,
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
                        const SizedBox(height: AdminSpacing.lg),
                        JobCategoryChart(
                          data: controller.jobsByCategory,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AdminSpacing.xxl),
                _topWorkersSection(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Header ─────────────────────────────────────────────────────

  Widget _header(AnalyticsController controller) {
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
                  Row(
                    children: [
                      const Icon(
                        Icons.analytics_rounded,
                        color: AdminColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: AdminSpacing.xs),
                      Text('Analytics & Reports', style: AdminTextStyles.h1),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Deep insights into platform performance and growth',
                    style: AdminTextStyles.bodySmallSecondary,
                  ),
                ],
              ),
            ),
            if (wide) const SizedBox(width: AdminSpacing.lg),
            Wrap(
              spacing: AdminSpacing.sm,
              runSpacing: AdminSpacing.sm,
              children: [
                // Export button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 17),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminColors.primary,
                    side: const BorderSide(color: AdminColors.primary),
                  ),
                ),
                // Date range selector
                FilterChip(
                  label: const Text('Last 30 days'),
                  selected: true,
                  onSelected: (_) {},
                  selectedColor: AdminColors.primaryLight,
                  labelStyle: const TextStyle(
                    color: AdminColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  checkmarkColor: AdminColors.primary,
                  side: const BorderSide(color: AdminColors.primary),
                ),
                FilledButton.icon(
                  onPressed: controller.fetchAnalytics,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Refresh Data'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── KPI row ────────────────────────────────────────────────────

  Widget _kpiRow(AnalyticsController controller) {
    final kpis = controller.kpis;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;
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
            children:
                items
                    .map(
                      (e) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: items.last == e ? 0 : AdminSpacing.sm,
                          ),
                          child: e,
                        ),
                      ),
                    )
                    .toList(),
          );
        }
        return Column(
          children:
              items
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: AdminSpacing.sm),
                      child: e,
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _kpiCard(
    String title,
    String value,
    String change,
    IconData icon,
  ) {
    final isPositiveChange = change.startsWith('+');
    final changeColor = isPositiveChange
        ? AdminColors.accent
        : AdminColors.danger;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AdminColors.primary, size: 18),
              const SizedBox(width: AdminSpacing.xs),
              Text(
                title,
                style: AdminTextStyles.captionWith(AdminColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.sm),
          Row(
            children: [
              Text(
                value,
                style: AdminTextStyles.h2,
              ),
              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: AdminTextStyles.captionWith(
                    changeColor,
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top workers ────────────────────────────────────────────────

  Widget _topWorkersSection(AnalyticsController controller) {
    final workers = controller.topWorkers;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AdminColors.warning,
                size: 22,
              ),
              const SizedBox(width: AdminSpacing.xs),
              Text('Top Performing Workers', style: AdminTextStyles.h3),
            ],
          ),
          const SizedBox(height: AdminSpacing.md),
          if (workers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No data available',
                  style: TextStyle(color: AdminColors.textSecondary),
                ),
              ),
            )
          else
            ...workers.asMap().entries.map((entry) {
              final index = entry.key;
              final w = entry.value;
              final rank = index + 1;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: AdminSpacing.sm),
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
                            ? AdminColors.warning.withValues(alpha: 0.15)
                            : AdminColors.neutral100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: rank == 1
                              ? AdminColors.warning.withValues(alpha: 0.3)
                              : AdminColors.borderDark,
                        ),
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
                    const SizedBox(width: AdminSpacing.sm),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          AdminColors.primaryLight,
                      child: Text(
                        w['name']?[0] ?? '?',
                        style: const TextStyle(
                          color: AdminColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AdminSpacing.sm),
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
                    const SizedBox(width: AdminSpacing.lg),
                    _miniInfo(Icons.star_rounded, '${w['rating'] ?? 0.0}'),
                    const SizedBox(width: AdminSpacing.lg),
                    Text(
                      '₦${w['earnings'] ?? 0}',
                      style: const TextStyle(
                        color: AdminColors.primary,
                        fontWeight: FontWeight.w700,
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
