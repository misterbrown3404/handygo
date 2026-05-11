import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  String _selectedFilter = 'All';

  static final _users = [
    {'name': 'Sarah Williams', 'email': 'sarah@email.com', 'phone': '+234 812 345 6789', 'jobs': '12', 'spend': 'N145,000', 'joined': 'Jan 2026', 'status': 'Active'},
    {'name': 'Michael Chen', 'email': 'michael@email.com', 'phone': '+234 903 456 7890', 'jobs': '8', 'spend': 'N85,000', 'joined': 'Feb 2026', 'status': 'Active'},
    {'name': 'Aisha Mohammed', 'email': 'aisha@email.com', 'phone': '+234 701 234 5678', 'jobs': '23', 'spend': 'N320,000', 'joined': 'Dec 2025', 'status': 'Active'},
    {'name': 'David Okafor', 'email': 'david@email.com', 'phone': '+234 815 678 9012', 'jobs': '5', 'spend': 'N45,000', 'joined': 'Apr 2026', 'status': 'Suspended'},
    {'name': 'Fatima Hassan', 'email': 'fatima@email.com', 'phone': '+234 906 789 0123', 'jobs': '15', 'spend': 'N210,000', 'joined': 'Mar 2026', 'status': 'Active'},
    {'name': 'Emmanuel John', 'email': 'emmanuel.j@email.com', 'phone': '+234 802 111 2222', 'jobs': '2', 'spend': 'N18,000', 'joined': 'May 2026', 'status': 'Pending'},
    {'name': 'Grace Obi', 'email': 'grace.obi@email.com', 'phone': '+234 705 999 8888', 'jobs': '0', 'spend': 'N0', 'joined': 'May 2026', 'status': 'Active'},
    {'name': 'Tunde Bakare', 'email': 'tbakare@email.com', 'phone': '+234 818 444 5555', 'jobs': '34', 'spend': 'N540,000', 'joined': 'Oct 2025', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _selectedFilter == 'All' ? _users : _users.where((u) => u['status'] == _selectedFilter).toList();

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
              title: 'Customer Directory',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AdminColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('${filteredUsers.length} Customers', style: const TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              columns: const [
                DataColumn(label: Text('CUSTOMER')),
                DataColumn(label: Text('PHONE')),
                DataColumn(label: Text('JOBS')),
                DataColumn(label: Text('TOTAL SPEND')),
                DataColumn(label: Text('JOINED')),
                DataColumn(label: Text('STATUS')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: filteredUsers.map((u) => DataRow(cells: [
                    DataCell(Row(children: [
                      _buildAvatar(u['name']!),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(u['name']!, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(u['email']!, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)),
                      ]),
                    ])),
                    DataCell(Text(u['phone']!, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13))),
                    DataCell(Text(u['jobs']!, style: const TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.w500))),
                    DataCell(Text(u['spend']!, style: const TextStyle(color: AdminColors.primary, fontWeight: FontWeight.bold))),
                    DataCell(Text(u['joined']!, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13))),
                    DataCell(StatusChip(label: u['status']!)),
                    DataCell(Row(children: [
                      _actionIcon(Icons.visibility_rounded, AdminColors.textSecondary, 'View Profile'),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.mail_outline_rounded, AdminColors.accent, 'Send Email'),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.block_rounded, AdminColors.error, 'Suspend User'),
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
            Text('Customer Management', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Manage, monitor, and support registered customers', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
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
              label: const Text('New Customer'),
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
                hintText: 'Search customers by name, email, or phone...',
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
          _filterChip('Active'),
          const SizedBox(width: 8),
          _filterChip('Pending'),
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
    // Generate a consistent color based on the name length for variety
    final colors = [AdminColors.primary, AdminColors.accent, AdminColors.warning, AdminColors.chart4];
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
