import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';

class RevenueChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const RevenueChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Convert data to spots
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value['revenue'] ?? 0).toDouble());
    }).toList();

    double maxY = 10000;
    if (spots.isNotEmpty) {
      maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
      maxY = (maxY * 1.2).clamp(10000, double.infinity);
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Overview',
                style: TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AdminColors.borderDark.withValues(alpha: 0.4),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '${(value / 1000).toInt()}k',
                          style: const TextStyle(
                            color: AdminColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[index]['period'] ?? '',
                              style: const TextStyle(
                                color: AdminColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble().clamp(0, double.infinity),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AdminColors.primary, AdminColors.accent],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AdminColors.primary.withValues(alpha: 0.25),
                          AdminColors.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: AdminColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots
                        .map(
                          (spot) => LineTooltipItem(
                            '₦${(spot.y / 1000).toStringAsFixed(1)}k',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        )
                        .toList(),
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
  final List<Map<String, dynamic>> data;
  const JobCategoryChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AdminColors.chart1,
      AdminColors.chart2,
      AdminColors.chart3,
      AdminColors.chart4,
      AdminColors.accent,
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jobs by Category',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (data.isEmpty)
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: AdminColors.textSecondary),
                ),
              ),
            ),
          if (data.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: data.asMap().entries.map((e) {
                    final index = e.key;
                    final val = e.value;
                    return PieChartSectionData(
                      value: (val['count'] as num).toDouble(),
                      color: colors[index % colors.length],
                      title: '${val['count']}',
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      radius: 55,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...data.asMap().entries.map(
              (e) => _legendItem(
                e.value['category'] ?? 'N/A',
                colors[e.key % colors.length],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AdminColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyJobsChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const WeeklyJobsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double maxY = 20;
    if (data.isNotEmpty) {
      maxY = data
          .map((d) => (d['completed'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);
      maxY = (maxY * 1.5).clamp(20, double.infinity);
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Job Volume',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (data.isEmpty)
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: AdminColors.textSecondary),
                ),
              ),
            ),
          if (data.isNotEmpty)
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AdminColors.borderDark.withValues(alpha: 0.4),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: AdminColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                data[index]['day'] ?? '',
                                style: const TextStyle(
                                  color: AdminColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((e) {
                    return _barGroup(
                      e.key,
                      (e.value['completed'] as num).toDouble(),
                      (e.value['pending'] as num).toDouble(),
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              _legendDot('Completed', AdminColors.primary),
              const SizedBox(width: 16),
              _legendDot('Pending', AdminColors.chart2),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double v1, double v2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: v1,
          color: AdminColors.primary,
          width: 10,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: v2,
          color: AdminColors.chart2,
          width: 10,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AdminColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
