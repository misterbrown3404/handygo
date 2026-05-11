import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revenue Overview', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AdminColors.borderDark),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('This Month', style: TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, color: AdminColors.textSecondary, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50000,
                  getDrawingHorizontalLine: (value) => FlLine(color: AdminColors.borderDark.withOpacity(0.4), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text('${(value / 1000).toInt()}k', style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() < days.length) {
                          return Padding(padding: const EdgeInsets.only(top: 8), child: Text(days[value.toInt()], style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0, maxX: 6, minY: 0, maxY: 200000,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 85000), FlSpot(1, 120000), FlSpot(2, 95000), FlSpot(3, 150000), FlSpot(4, 130000), FlSpot(5, 175000), FlSpot(6, 160000)],
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AdminColors.primary, AdminColors.accent]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AdminColors.primary.withOpacity(0.25), AdminColors.primary.withOpacity(0.0)]),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: AdminColors.primary, strokeWidth: 2, strokeColor: Colors.white),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) => LineTooltipItem(
                          'N${(spot.y / 1000).toStringAsFixed(0)}k',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobCategoryChart extends StatelessWidget {
  const JobCategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Jobs by Category', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(value: 35, color: AdminColors.chart1, title: '35%', titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), radius: 55),
                  PieChartSectionData(value: 25, color: AdminColors.chart2, title: '25%', titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), radius: 55),
                  PieChartSectionData(value: 20, color: AdminColors.chart3, title: '20%', titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), radius: 55),
                  PieChartSectionData(value: 20, color: AdminColors.chart4, title: '20%', titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), radius: 55),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _legendItem('Plumbing', AdminColors.chart1),
          _legendItem('Electrical', AdminColors.chart2),
          _legendItem('Cleaning', AdminColors.chart3),
          _legendItem('AC Repair', AdminColors.chart4),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class WeeklyJobsChart extends StatelessWidget {
  const WeeklyJobsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Job Volume', style: TextStyle(color: AdminColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20, getDrawingHorizontalLine: (value) => FlLine(color: AdminColors.borderDark.withOpacity(0.4), strokeWidth: 1)),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return value.toInt() < days.length ? Padding(padding: const EdgeInsets.only(top: 8), child: Text(days[value.toInt()], style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11))) : const SizedBox.shrink();
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [_barGroup(0, 45, 30), _barGroup(1, 60, 42), _barGroup(2, 55, 38), _barGroup(3, 75, 50), _barGroup(4, 68, 48), _barGroup(5, 40, 25), _barGroup(6, 35, 20)],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [_legendDot('Completed', AdminColors.primary), const SizedBox(width: 16), _legendDot('Pending', AdminColors.chart2)]),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double v1, double v2) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: v1, color: AdminColors.primary, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      BarChartRodData(toY: v2, color: AdminColors.chart2, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
    ]);
  }

  Widget _legendDot(String label, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
    ]);
  }
}
