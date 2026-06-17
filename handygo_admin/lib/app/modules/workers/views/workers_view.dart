import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
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
  bool _showPendingOnly = false;
  List<Map<String, dynamic>> _workers = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AdminColors.primary),
              )
            : _error != null
                ? _errorView(_error!)
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AdminSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),
                        const SizedBox(height: AdminSpacing.lg),
                        _searchAndFilterRow(context),
                        const SizedBox(height: AdminSpacing.lg),
                        _resultsTable(),
                      ],
                    ),
                  ),
      ),
    );
  }

  // ── Filter logic ───────────────────────────────────────────────

  List<Map<String, dynamic>> _filteredWorkers() {
    final query = _searchCtrl.text.trim().toLowerCase();
    return _workers.where((w) {
      // Level-1 filter tabs
      if (_selectedFilter == 'Subscribed') {
        if (w['has_active_subscription'] != true) return false;
      } else if (_selectedFilter == 'Unsubscribed') {
        if (w['has_active_subscription'] == true) return false;
      } else if (_selectedFilter != 'All') {
        final s = (w['status'] ?? '').toString().toLowerCase();
        if (s != _selectedFilter.toLowerCase()) return false;
      }
      // Pending-only toggle
      if (_showPendingOnly &&
          (w['status'] ?? '').toString().toLowerCase() != 'pending') {
        return false;
      }
      // Search
      if (query.isNotEmpty) {
        final name = (w['name'] ?? '').toString().toLowerCase();
        final specialty = (w['specialty'] ?? '').toString().toLowerCase();
        if (!name.contains(query) && !specialty.contains(query)) return false;
      }
      return true;
    }).toList();
  }

  // ── Error / empty ──────────────────────────────────────────────

  Widget _errorView(String msg) {
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
                size: 56,
              ),
            ),
            const SizedBox(height: AdminSpacing.lg),
            Text(
              msg,
              style: AdminTextStyles.bodyWith(AdminColors.textSecondary),
            ),
            const SizedBox(height: AdminSpacing.lg),
            ElevatedButton(onPressed: _fetchWorkers, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _noWorkersEmpty(String message, {bool showSearch = false}) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.engineering_outlined,
            size: 56,
            color: AdminColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AdminSpacing.sm),
          Text('No workers found', style: AdminTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            message,
            style: AdminTextStyles.bodySmallSecondary,
            textAlign: TextAlign.center,
          ),
          if (showSearch) ...[
            const SizedBox(height: AdminSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _searchCtrl.clear(),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }

  // ── Results table ──────────────────────────────────────────────

  Widget _resultsTable() {
    final workers = _filteredWorkers();

    return workers.isEmpty
        ? _noWorkersEmpty(
            _searchCtrl.text.isEmpty
                ? 'Worker list is currently empty.'
                : 'Try adjusting your search or filter criteria.',
            showSearch: _searchCtrl.text.isNotEmpty,
          )
        : GlassDataTable(
            title: 'Worker Directory',
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AdminSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AdminColors.primaryLight,
                borderRadius: BorderRadius.circular(AdminSpacing.xs),
              ),
              child: Text(
                '${workers.length} Workers',
                style: const TextStyle(
                  color: AdminColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
            rows: workers.map((w) {
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
                      style: const TextStyle(color: AdminColors.textSecondary),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      totalJobs,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    StatusChip(label: _capitalize(status)),
                  ),
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
          );
  }

  // ── Header ─────────────────────────────────────────────────────

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Worker Management', style: AdminTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Monitor worker performance, subscriptions, and KYC status',
                style: AdminTextStyles.bodySmallSecondary,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _fetchWorkers,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  // ── Search & filter row ────────────────────────────────────────

  Widget _searchAndFilterRow(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile) {
      return Column(
        children: [
          _buildSearchBox(),
          const SizedBox(height: AdminSpacing.md),
          Wrap(
            spacing: AdminSpacing.xs,
            runSpacing: AdminSpacing.xs,
            children: [
              _buildPendingOnlyToggle(),
              ..._buildFilterTabs(),
            ],
          ),
        ],
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(flex: 2, child: _buildSearchBox()),
        const SizedBox(width: AdminSpacing.md),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: AdminSpacing.xs,
            runSpacing: AdminSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildPendingOnlyToggle(),
              ..._buildFilterTabs(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingOnlyToggle() {
    final isOn = _showPendingOnly;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            size: 16,
            color: isOn
                ? AdminColors.surface
                : AdminColors.warning,
          ),
          const SizedBox(width: 4),
          const Text('Pending only'),
        ],
      ),
      selected: isOn,
      onSelected: (v) => setState(() => _showPendingOnly = v),
      selectedColor: AdminColors.warning,
      checkmarkColor: AdminColors.surface,
      backgroundColor: AdminColors.neutral100,
      side: BorderSide(
        color: isOn
            ? AdminColors.warning
            : AdminColors.borderDark,
      ),
      labelStyle: TextStyle(
        color: isOn ? AdminColors.surface : AdminColors.textSecondary,
        fontWeight: isOn ? FontWeight.w600 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminSpacing.sm),
      ),
    );
  }

  List<Widget> _buildFilterTabs() {
    return ['All', 'Subscribed', 'Unsubscribed', 'Active', 'Suspended']
        .map(
          (label) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _filterChip(label),
          ),
        )
        .toList();
  }

  Widget _buildSearchBox() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AdminSpacing.sm,
        vertical: AdminSpacing.xs,
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AdminColors.textSecondary),
          const SizedBox(width: AdminSpacing.sm - 2),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AdminColors.textPrimary),
              decoration: const InputDecoration(
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
          const SizedBox(width: AdminSpacing.xs),
          const Icon(
            Icons.tune_rounded,
            color: AdminColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      borderRadius: BorderRadius.circular(AdminSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md - 2,
          vertical: AdminSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AdminColors.primaryLight
              : AdminColors.surface,
          borderRadius: BorderRadius.circular(AdminSpacing.sm),
          border: Border.all(
            color: isSelected
                ? AdminColors.primary.withValues(alpha: 0.5)
                : AdminColors.borderDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AdminColors.primary
                : AdminColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Avatar & action ────────────────────────────────────────────

  Widget _buildAvatar(String name) {
    final colors = [
      AdminColors.chart2,
      AdminColors.primary,
      AdminColors.accent,
      AdminColors.warning,
    ];
    final color = colors[name.length % colors.length];
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.25)),
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
          borderRadius: BorderRadius.circular(AdminSpacing.xs),
          hoverColor: color.withValues(alpha: 0.10),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
