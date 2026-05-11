import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/modules/analytics/widgets/charts.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

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
            _kpiRow(),
            const SizedBox(height: 32),
            const RevenueChart(),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: WeeklyJobsChart()),
                    SizedBox(width: 24),
                    Expanded(child: JobCategoryChart()),
                  ]);
                }
                return const Column(children: [WeeklyJobsChart(), SizedBox(height: 24), JobCategoryChart()]);
              },
            ),
            const SizedBox(height: 32),
            _topWorkersSection(),
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
            Text('Analytics & Reports', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Deep insights into platform performance and growth', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [_periodChip('7 Days', false), _periodChip('30 Days', true), _periodChip('90 Days', false)],
        ),
      ],
    );
  }

  Widget _periodChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AdminColors.primary.withOpacity(0.15) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? AdminColors.primary.withOpacity(0.4) : AdminColors.borderDark.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? AdminColors.primary : AdminColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _kpiRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final items = [
          _kpiCard('Avg. Job Value', 'N8,500', '+5.2%', Icons.trending_up_rounded),
          _kpiCard('Worker Retention', '92%', '+2.1%', Icons.people_rounded),
          _kpiCard('Avg. Response Time', '4.2 min', '-12%', Icons.timer_rounded),
          _kpiCard('Cancellation Rate', '3.8%', '-0.5%', Icons.cancel_outlined),
        ];
        if (isWide) {
          return Row(children: items.map((e) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: e))).toList());
        }
        return Column(children: items.map((e) => Padding(padding: const EdgeInsets.only(bottom: 16), child: e)).toList());
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
              Text(title, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(value, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AdminColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(change, style: const TextStyle(color: AdminColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topWorkersSection() {
    final workers = [
      {'rank': '1', 'name': 'Chinedu Okonkwo', 'service': 'Plumbing', 'jobs': '142', 'rating': '4.9', 'earnings': 'N520,000'},
      {'rank': '2', 'name': 'Ibrahim Musa', 'service': 'Carpentry', 'jobs': '128', 'rating': '4.9', 'earnings': 'N480,000'},
      {'rank': '3', 'name': 'Emeka Eze', 'service': 'Electrical', 'jobs': '115', 'rating': '4.8', 'earnings': 'N420,000'},
      {'rank': '4', 'name': 'Amina Bello', 'service': 'Cleaning', 'jobs': '98', 'rating': '4.7', 'earnings': 'N310,000'},
      {'rank': '5', 'name': 'Grace Obi', 'service': 'AC Repair', 'jobs': '87', 'rating': '4.8', 'earnings': 'N290,000'},
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: AdminColors.warning, size: 22),
              SizedBox(width: 8),
              Text('Top Performing Workers', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ...workers.map((w) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.borderDark.withOpacity(0.3)))),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: w['rank'] == '1' ? AdminColors.warning.withOpacity(0.2) : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('#${w['rank']}', style: TextStyle(color: w['rank'] == '1' ? AdminColors.warning : AdminColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(radius: 16, backgroundColor: AdminColors.primary.withOpacity(0.15), child: Text(w['name']![0], style: const TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(w['name']!, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(w['service']!, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)),
                      ]),
                    ),
                    _miniInfo(Icons.task_alt_rounded, '${w['jobs']} jobs'),
                    const SizedBox(width: 24),
                    _miniInfo(Icons.star_rounded, w['rating']!),
                    const SizedBox(width: 24),
                    Text(w['earnings']!, style: const TextStyle(color: AdminColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 14, color: AdminColors.textSecondary),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
    ]);
  }
}
