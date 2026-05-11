import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/stat_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/modules/analytics/widgets/charts.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 32),
            _statsRow(),
            const SizedBox(height: 32),
            _chartsRow(),
            const SizedBox(height: 32),
            _bottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Welcome back, Admin. Here\'s your platform overview.', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded, color: AdminColors.textSecondary, size: 16),
                  SizedBox(width: 8),
                  Text('May 2026', style: TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AdminColors.primary, AdminColors.primaryDark]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AdminColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 2.0,
          children: const [
            StatCard(title: 'Total Revenue', value: 'N2,450,000', change: '+12.5%', icon: Icons.payments_rounded, color: AdminColors.primary),
            StatCard(title: 'Active Workers', value: '342', change: '+8.2%', icon: Icons.engineering_rounded, color: AdminColors.accent),
            StatCard(title: 'Completed Jobs', value: '1,847', change: '+15.3%', icon: Icons.task_alt_rounded, color: AdminColors.warning),
            StatCard(title: 'Customer Satisfaction', value: '4.8/5', change: '+0.3', icon: Icons.star_rounded, color: AdminColors.chart4),
          ],
        );
      },
    );
  }

  Widget _chartsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(flex: 2, child: RevenueChart()), SizedBox(width: 24), Expanded(child: JobCategoryChart())],
          );
        }
        return const Column(children: [RevenueChart(), SizedBox(height: 24), JobCategoryChart()]);
      },
    );
  }

  Widget _bottomSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(child: WeeklyJobsChart()),
            const SizedBox(width: 24),
            Expanded(child: _recentActivity()),
          ]);
        }
        return Column(children: [const WeeklyJobsChart(), const SizedBox(height: 24), _recentActivity()]);
      },
    );
  }

  Widget _recentActivity() {
    final activities = [
      {'title': 'New worker registration', 'sub': 'Chinedu Okonkwo signed up', 'time': '2m ago', 'icon': Icons.person_add_rounded, 'color': AdminColors.primary},
      {'title': 'KYC Verification Request', 'sub': 'Amina Bello submitted NIN', 'time': '15m ago', 'icon': Icons.verified_user_rounded, 'color': AdminColors.warning},
      {'title': 'Job Completed', 'sub': 'Plumbing service at Lekki', 'time': '1h ago', 'icon': Icons.check_circle_rounded, 'color': AdminColors.success},
      {'title': 'Withdrawal Processed', 'sub': 'N45,000 to GTBank', 'time': '2h ago', 'icon': Icons.account_balance_rounded, 'color': AdminColors.accent},
      {'title': 'New Dispute Filed', 'sub': 'Job #4521 - Cleaning service', 'time': '3h ago', 'icon': Icons.warning_rounded, 'color': AdminColors.error},
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activity', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AdminColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Text('View All', style: TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((a) => _activityItem(a['title'] as String, a['sub'] as String, a['time'] as String, a['icon'] as IconData, a['color'] as Color)),
        ],
      ),
    );
  }

  Widget _activityItem(String title, String sub, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(sub, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
