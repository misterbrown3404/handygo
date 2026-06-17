import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';
import 'package:intl/intl.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  String _selectedFilter = 'All Jobs';
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final queryParams = <String, dynamic>{};
      if (_selectedFilter != 'All Jobs') {
        queryParams['status'] = _selectedFilter.toLowerCase().replaceAll(
          ' ',
          '_',
        );
      }

      final response = await _api.get(
        AdminApiConstants.jobs,
        queryParameters: queryParams,
      );
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

        _jobs = dataList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      _error = 'Failed to load jobs';
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
                        _resultsTable(context),
                      ],
                    ),
                  ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────

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
                size: 48,
              ),
            ),
            const SizedBox(height: AdminSpacing.sm),
            Text(
              msg,
              style: AdminTextStyles.bodyWith(AdminColors.textSecondary),
            ),
            const SizedBox(height: AdminSpacing.sm),
            ElevatedButton(onPressed: _fetchJobs, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _noJobsEmpty(String message, {bool showSearch = false}) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 56,
            color: AdminColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AdminSpacing.sm),
          Text('No jobs found', style: AdminTextStyles.h3),
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

  String _formatDate(String raw) {
    if (raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty
          ? s
          : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');

  // ── Header ─────────────────────────────────────────────────────

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Management', style: AdminTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Track and manage all service jobs across the platform',
                style: AdminTextStyles.bodySmallSecondary,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _fetchJobs,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  // ── Search & filter ────────────────────────────────────────────

  Widget _searchAndFilterRow(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile) {
      return Column(
        children: [
          _buildSearchBox(),
          const SizedBox(height: AdminSpacing.md),
          _buildFilterTabs(),
        ],
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(flex: 2, child: _buildSearchBox()),
        const SizedBox(width: AdminSpacing.md),
        Expanded(flex: 3, child: _buildFilterTabs()),
      ],
    );
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
          const SizedBox(width: AdminSpacing.xs),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AdminColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search by Job ID, Customer, or Worker...',
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

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          _filterChip('All Jobs'),
          _filterChip('Pending'),
          _filterChip('In Progress'),
          _filterChip('Completed'),
          _filterChip('Disputed'),
          _filterChip('Cancelled'),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() => _selectedFilter = label);
        _fetchJobs();
      },
      borderRadius: BorderRadius.circular(AdminSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.sm + 4,
          vertical: AdminSpacing.xs + 4,
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

  // ── Results table ──────────────────────────────────────────────

  Widget _resultsTable(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = _jobs.where((j) {
      if (query.isNotEmpty) {
        final id = (j['job_id'] ?? '').toString().toLowerCase();
        final customer = (j['customer']?['name'] ?? '')
            .toString()
            .toLowerCase();
        final worker = (j['worker']?['name'] ?? '').toString().toLowerCase();
        return id.contains(query) ||
            customer.contains(query) ||
            worker.contains(query);
      }
      return true;
    }).toList();

    return filtered.isEmpty
        ? _noJobsEmpty(
            query.isEmpty
                ? 'No job records have been created yet.'
                : 'No job matches your search.',
            showSearch: query.isNotEmpty,
          )
        : GlassDataTable(
            title: 'Service Jobs Log',
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
                '${filtered.length} Records',
                style: const TextStyle(
                  color: AdminColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
            rows: filtered.map((j) {
              final jobId = j['job_id'] ?? '#0000';
              final customerName = j['customer']?['name'] ?? 'N/A';
              final workerName = j['worker']?['name'] ?? 'Unassigned';
              final serviceName = j['service']?['name'] ?? 'N/A';
              final amount = j['amount']?.toString() ?? '0';
              final date = _formatDate(j['date'] ?? '');
              final status = _capitalize(j['status'] ?? 'pending');

              return DataRow(
                cells: [
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AdminColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        jobId,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AdminColors.primary,
                          fontSize: 12,
                          fontFamily: 'Menlo, Consolas, monospace',
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      workerName,
                      style: TextStyle(
                        color: workerName == 'Unassigned'
                            ? AdminColors.warning
                            : AdminColors.textPrimary,
                        fontStyle: workerName == 'Unassigned'
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      serviceName,
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '₦$amount',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      date,
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(StatusChip(label: status)),
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
}
