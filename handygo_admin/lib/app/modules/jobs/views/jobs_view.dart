import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  String _selectedFilter = 'All Jobs';

  static final _jobs = [
    {'id': '#4521', 'customer': 'Sarah Williams', 'worker': 'Chinedu Okonkwo', 'service': 'Plumbing', 'amount': 'N12,500', 'status': 'Completed', 'date': 'May 10, 2026'},
    {'id': '#4520', 'customer': 'Michael Chen', 'worker': 'Emeka Eze', 'service': 'Electrical', 'amount': 'N8,000', 'status': 'In Progress', 'date': 'May 10, 2026'},
    {'id': '#4519', 'customer': 'Aisha Mohammed', 'worker': 'Ibrahim Musa', 'service': 'Carpentry', 'amount': 'N25,000', 'status': 'Completed', 'date': 'May 9, 2026'},
    {'id': '#4518', 'customer': 'David Okafor', 'worker': 'Amina Bello', 'service': 'Cleaning', 'amount': 'N6,000', 'status': 'Disputed', 'date': 'May 9, 2026'},
    {'id': '#4517', 'customer': 'Fatima Hassan', 'worker': 'Blessing Adeyemi', 'service': 'AC Repair', 'amount': 'N15,000', 'status': 'Cancelled', 'date': 'May 8, 2026'},
    {'id': '#4516', 'customer': 'Grace Obi', 'worker': 'Samuel Ojo', 'service': 'Painting', 'amount': 'N35,000', 'status': 'Completed', 'date': 'May 8, 2026'},
    {'id': '#4515', 'customer': 'Tunde Bakare', 'worker': 'Unassigned', 'service': 'Plumbing', 'amount': 'N10,000', 'status': 'Pending', 'date': 'May 7, 2026'},
    {'id': '#4514', 'customer': 'Emmanuel John', 'worker': 'Grace Alabi', 'service': 'Cleaning', 'amount': 'N5,000', 'status': 'In Progress', 'date': 'May 7, 2026'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredJobs;
    if (_selectedFilter == 'All Jobs') {
      filteredJobs = _jobs;
    } else {
      filteredJobs = _jobs.where((j) => j['status'] == _selectedFilter).toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            _searchAndFilterRow(context),
            const SizedBox(height: 24),
            GlassDataTable(
              title: 'Service Jobs Log',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AdminColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('${filteredJobs.length} Records', style: const TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              columns: const [
                DataColumn(label: Text('JOB ID')),
                DataColumn(label: Text('CUSTOMER')),
                DataColumn(label: Text('WORKER')),
                DataColumn(label: Text('SERVICE')),
                DataColumn(label: Text('AMOUNT')),
                DataColumn(label: Text('DATE')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: filteredJobs.map((j) => DataRow(cells: [
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AdminColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(j['id']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AdminColors.primary, fontSize: 12)),
                      )
                    ),
                    DataCell(Text(j['customer']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(j['worker']!, style: TextStyle(color: j['worker'] == 'Unassigned' ? AdminColors.warning : AdminColors.textPrimary, fontStyle: j['worker'] == 'Unassigned' ? FontStyle.italic : FontStyle.normal))),
                    DataCell(Text(j['service']!, style: const TextStyle(color: AdminColors.textSecondary))),
                    DataCell(Text(j['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(j['date']!, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13))),
                    DataCell(StatusChip(label: j['status']!)),
                    DataCell(Row(children: [
                      _actionIcon(Icons.visibility_rounded, AdminColors.textSecondary, 'View Details'),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.more_vert_rounded, AdminColors.textSecondary, 'More Options'),
                    ])),
                  ])).toList(),
            ),
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
            Text('Job Management', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Track and manage all service jobs across the platform', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AdminColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AdminColors.borderDark)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_task_rounded, size: 18),
              label: const Text('Create Job'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AdminColors.primary.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchAndFilterRow(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) ...[
          _buildSearchBox(),
          const SizedBox(height: 16),
          _buildFilterTabs(),
        ] else ...[
          Expanded(flex: 2, child: _buildSearchBox()),
          const SizedBox(width: 24),
          Expanded(flex: 3, child: _buildFilterTabs()),
        ]
      ],
    );
  }

  Widget _buildSearchBox() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AdminColors.textSecondary),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              style: TextStyle(color: AdminColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by Job ID, Customer, or Worker...',
                hintStyle: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AdminColors.borderDark),
          const SizedBox(width: 12),
          const Icon(Icons.tune_rounded, color: AdminColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('All Jobs', '1,847'),
          const SizedBox(width: 8),
          _filterChip('Pending', '15'),
          const SizedBox(width: 8),
          _filterChip('In Progress', '23'),
          const SizedBox(width: 8),
          _filterChip('Completed', '1,790'),
          const SizedBox(width: 8),
          _filterChip('Disputed', '12'),
          const SizedBox(width: 8),
          _filterChip('Cancelled', '22'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String count) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AdminColors.primary.withOpacity(0.5) : AdminColors.borderDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AdminColors.primary : AdminColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AdminColors.primary.withOpacity(0.2) : AdminColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(count, style: TextStyle(color: isSelected ? AdminColors.primary : AdminColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          hoverColor: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
