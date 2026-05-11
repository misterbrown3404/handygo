import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';

class WorkersView extends StatefulWidget {
  const WorkersView({super.key});

  @override
  State<WorkersView> createState() => _WorkersViewState();
}

class _WorkersViewState extends State<WorkersView> {
  String _selectedFilter = 'All';

  static final _workers = [
    {'name': 'Chinedu Okonkwo', 'service': 'Plumbing', 'rating': '4.9', 'jobs': '120', 'earnings': 'N450,000', 'kyc': 'Verified', 'status': 'Active'},
    {'name': 'Amina Bello', 'service': 'Cleaning', 'rating': '4.7', 'jobs': '85', 'earnings': 'N280,000', 'kyc': 'Pending', 'status': 'Active'},
    {'name': 'Emeka Eze', 'service': 'Electrical', 'rating': '4.8', 'jobs': '95', 'earnings': 'N380,000', 'kyc': 'Verified', 'status': 'Active'},
    {'name': 'Blessing Adeyemi', 'service': 'AC Repair', 'rating': '4.6', 'jobs': '60', 'earnings': 'N220,000', 'kyc': 'Rejected', 'status': 'Suspended'},
    {'name': 'Ibrahim Musa', 'service': 'Carpentry', 'rating': '4.9', 'jobs': '140', 'earnings': 'N520,000', 'kyc': 'Verified', 'status': 'Active'},
    {'name': 'Grace Alabi', 'service': 'Cleaning', 'rating': '4.5', 'jobs': '42', 'earnings': 'N150,000', 'kyc': 'Pending', 'status': 'Pending'},
    {'name': 'Samuel Ojo', 'service': 'Painting', 'rating': '5.0', 'jobs': '12', 'earnings': 'N85,000', 'kyc': 'Verified', 'status': 'Active'},
    {'name': 'Ngozi Chukwu', 'service': 'Plumbing', 'rating': '4.2', 'jobs': '15', 'earnings': 'N45,000', 'kyc': 'Pending', 'status': 'Suspended'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredWorkers;
    if (_selectedFilter == 'All') {
      filteredWorkers = _workers;
    } else if (_selectedFilter == 'Verified KYC') {
      filteredWorkers = _workers.where((w) => w['kyc'] == 'Verified').toList();
    } else if (_selectedFilter == 'Pending KYC') {
      filteredWorkers = _workers.where((w) => w['kyc'] == 'Pending').toList();
    } else {
      filteredWorkers = _workers.where((w) => w['status'] == _selectedFilter).toList();
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
              title: 'Worker Directory',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AdminColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('${filteredWorkers.length} Workers', style: const TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              columns: const [
                DataColumn(label: Text('WORKER')),
                DataColumn(label: Text('SERVICE')),
                DataColumn(label: Text('RATING')),
                DataColumn(label: Text('JOBS')),
                DataColumn(label: Text('EARNINGS')),
                DataColumn(label: Text('KYC')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: filteredWorkers.map((w) => DataRow(cells: [
                    DataCell(Row(children: [
                      _buildAvatar(w['name']!),
                      const SizedBox(width: 12),
                      Text(w['name']!, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ])),
                    DataCell(Text(w['service']!, style: const TextStyle(color: AdminColors.textSecondary))),
                    DataCell(Row(children: [
                      const Icon(Icons.star_rounded, color: AdminColors.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(w['rating']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ])),
                    DataCell(Text(w['jobs']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(w['earnings']!, style: const TextStyle(color: AdminColors.primary, fontWeight: FontWeight.bold))),
                    DataCell(StatusChip(label: w['kyc']!)),
                    DataCell(StatusChip(label: w['status']!)),
                    DataCell(Row(children: [
                      _actionIcon(Icons.visibility_rounded, AdminColors.textSecondary, 'View Details'),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.edit_rounded, AdminColors.accent, 'Edit Worker'),
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
            Text('Worker Management', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Monitor worker performance, KYC status, and earnings', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: const Text('Export CSV'),
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
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Add Worker'),
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
                hintText: 'Search workers by name or service...',
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
          _filterChip('All'),
          const SizedBox(width: 8),
          _filterChip('Verified KYC'),
          const SizedBox(width: 8),
          _filterChip('Pending KYC'),
          const SizedBox(width: 8),
          _filterChip('Suspended'),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AdminColors.primary.withOpacity(0.5) : AdminColors.borderDark),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AdminColors.primary : AdminColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    final colors = [AdminColors.chart2, AdminColors.primary, AdminColors.success, AdminColors.warning];
    final color = colors[name.length % colors.length];
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
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
