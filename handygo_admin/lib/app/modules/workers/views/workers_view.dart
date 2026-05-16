import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class WorkersView extends StatefulWidget {
  const WorkersView({super.key});

  @override
  State<WorkersView> createState() => _WorkersViewState();
}

class _WorkersViewState extends State<WorkersView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _workers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  Future<void> _fetchWorkers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _api.get(AdminApiConstants.workers);
      if (response.statusCode == 200) {
        var rawData = response.data['data'];
        List dataList = [];

        if (rawData is Map && rawData.containsKey('data')) {
          dataList = rawData['data'];
        } else if (rawData is List) {
          dataList = rawData;
        } else {
          dataList = response.data as List;
        }

        _workers = dataList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      _error = 'Failed to load workers';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkers;
    if (_selectedFilter == 'All') {
      filteredWorkers = _workers;
    } else if (_selectedFilter == 'Subscribed') {
      filteredWorkers = _workers
          .where((w) => w['has_active_subscription'] == true)
          .toList();
    } else if (_selectedFilter == 'Unsubscribed') {
      filteredWorkers = _workers
          .where((w) => w['has_active_subscription'] != true)
          .toList();
    } else {
      filteredWorkers = _workers
          .where(
            (w) =>
                (w['status'] ?? '').toString().toLowerCase() ==
                _selectedFilter.toLowerCase(),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
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
                    _error!,
                    style: const TextStyle(color: AdminColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchWorkers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${filteredWorkers.length} Workers',
                        style: const TextStyle(
                          color: AdminColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    columns: const [
                      DataColumn(label: Text('WORKER')),
                      DataColumn(label: Text('SPECIALTY')),
                      DataColumn(label: Text('RATING')),
                      DataColumn(label: Text('JOBS')),
                      DataColumn(label: Text('STATUS')),
                      DataColumn(label: Text('SUBSCRIPTION')),
                      DataColumn(label: Text('ACTIONS')),
                    ],
                    rows: filteredWorkers.map((w) {
                      final name = w['name'] ?? 'Unknown';
                      final specialty = w['specialty'] ?? 'N/A';
                      final rating = w['rating']?.toString() ?? '0.0';
                      final totalJobs = w['total_jobs']?.toString() ?? '0';
                      final status = w['status'] ?? 'inactive';
                      final hasSub = w['has_active_subscription'] == true;

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                _buildAvatar(name),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      color: AdminColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              specialty,
                              style: const TextStyle(
                                color: AdminColors.textSecondary,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AdminColors.warning,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              totalJobs,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DataCell(StatusChip(label: _capitalize(status))),
                          DataCell(
                            StatusChip(label: hasSub ? 'Active' : 'None'),
                          ),
                          DataCell(
                            Row(
                              children: [
                                _actionIcon(
                                  Icons.visibility_rounded,
                                  AdminColors.textSecondary,
                                  'View Details',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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
            Text(
              'Worker Management',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Monitor worker performance, subscriptions, and KYC status',
              style: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _fetchWorkers,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AdminColors.primary.withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
        ],
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
                hintText: 'Search workers by name or specialty...',
                hintStyle: TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AdminColors.borderDark),
          const SizedBox(width: 12),
          const Icon(
            Icons.tune_rounded,
            color: AdminColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['All', 'Subscribed', 'Unsubscribed', 'Active', 'Suspended']
            .map(
              (label) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _filterChip(label),
              ),
            )
            .toList(),
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
          color: isSelected
              ? AdminColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AdminColors.primary.withValues(alpha: 0.5)
                : AdminColors.borderDark,
          ),
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
    final colors = [
      AdminColors.chart2,
      AdminColors.primary,
      AdminColors.success,
      AdminColors.warning,
    ];
    final color = colors[name.length % colors.length];
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
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
          hoverColor: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
