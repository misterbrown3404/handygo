import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';

class KycView extends StatelessWidget {
  const KycView({super.key});

  static final _requests = [
    {'name': 'Amina Bello', 'nin': '123****5678', 'bvn': '987****4321', 'date': 'May 10, 2026', 'service': 'Cleaning', 'status': 'Pending'},
    {'name': 'Chinedu Okonkwo', 'nin': '456****7890', 'bvn': '654****3210', 'date': 'May 9, 2026', 'service': 'Plumbing', 'status': 'Verified'},
    {'name': 'Blessing Adeyemi', 'nin': '789****0123', 'bvn': '321****0987', 'date': 'May 8, 2026', 'service': 'AC Repair', 'status': 'Rejected'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KYC Verification', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Review and approve worker identity documents (NIN & BVN)', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 24),
            _kycStats(context),
            const SizedBox(height: 24),
            GlassDataTable(
              title: 'Verification Queue',
              columns: const [
                DataColumn(label: Text('WORKER')),
                DataColumn(label: Text('NIN')),
                DataColumn(label: Text('BVN')),
                DataColumn(label: Text('SERVICE')),
                DataColumn(label: Text('SUBMITTED')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: _requests.map((r) => DataRow(cells: [
                    DataCell(Row(children: [
                      CircleAvatar(radius: 16, backgroundColor: AdminColors.warning.withOpacity(0.15), child: Text(r['name']![0], style: const TextStyle(color: AdminColors.warning, fontSize: 12, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12),
                      Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ])),
                    DataCell(Text(r['nin']!, style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1))),
                    DataCell(Text(r['bvn']!, style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1))),
                    DataCell(Text(r['service']!)),
                    DataCell(Text(r['date']!)),
                    DataCell(StatusChip(label: r['status']!)),
                    DataCell(r['status'] == 'Pending'
                        ? Row(children: [_actionBtn('Approve', AdminColors.success), const SizedBox(width: 8), _actionBtn('Reject', AdminColors.error)])
                        : const SizedBox.shrink()),
                  ])).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kycStats(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      children: [
        if (isMobile) ...[
          _miniStat('Pending Review', '8', AdminColors.warning, Icons.hourglass_top_rounded),
          const SizedBox(height: 16),
          _miniStat('Verified Today', '12', AdminColors.success, Icons.verified_rounded),
          const SizedBox(height: 16),
          _miniStat('Rejected', '3', AdminColors.error, Icons.cancel_rounded),
        ] else ...[
          Expanded(child: _miniStat('Pending Review', '8', AdminColors.warning, Icons.hourglass_top_rounded)),
          const SizedBox(width: 16),
          Expanded(child: _miniStat('Verified Today', '12', AdminColors.success, Icons.verified_rounded)),
          const SizedBox(width: 16),
          Expanded(child: _miniStat('Rejected', '3', AdminColors.error, Icons.cancel_rounded)),
        ]
      ],
    );
  }

  Widget _miniStat(String label, String value, Color color, IconData icon) {
    return GlassCard(
      glowColor: color,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
