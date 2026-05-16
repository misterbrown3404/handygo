import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final queryParams = <String, dynamic>{};
      if (_selectedFilter != 'All Jobs') {
        queryParams['status'] = _selectedFilter.toLowerCase().replaceAll(' ', '_');
      }

      final response = await _api.get(AdminApiConstants.jobs, queryParameters: queryParams);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: AdminColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: AdminColors.textSecondary)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _fetchJobs, child: const Text('Retry')),
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
                        title: 'Service Jobs Log',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AdminColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_jobs.length} Records',
                            style: const TextStyle(color: AdminColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
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
                        rows: _jobs.map((j) {
                          final jobId = j['job_id'] ?? '#0000';
                          final customerName = j['customer']?['name'] ?? 'N/A';
                          final workerName = j['worker']?['name'] ?? 'Unassigned';
                          final serviceName = j['service']?['name'] ?? 'N/A';
                          final amount = j['amount']?.toString() ?? '0';
                          final date = _formatDate(j['date'] ?? '');
                          final status = _capitalize(j['status'] ?? 'pending');

                          return DataRow(cells: [
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AdminColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(jobId, style: const TextStyle(fontWeight: FontWeight.bold, color: AdminColors.primary, fontSize: 12)),
                              ),
                            ),
                            DataCell(Text(customerName, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(workerName,
                                style: TextStyle(
                                    color: workerName == 'Unassigned' ? AdminColors.warning : AdminColors.textPrimary,
                                    fontStyle: workerName == 'Unassigned' ? FontStyle.italic : FontStyle.normal))),
                            DataCell(Text(serviceName, style: const TextStyle(color: AdminColors.textSecondary))),
                            DataCell(Text('₦$amount', style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(date, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13))),
                            DataCell(StatusChip(label: status)),
                            DataCell(Row(children: [
                              _actionIcon(Icons.visibility_rounded, AdminColors.textSecondary, 'View Details'),
                            ])),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ),
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

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');

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
        ElevatedButton.icon(
          onPressed: _fetchJobs,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AdminColors.primary.withValues(alpha: 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          _filterChip('All Jobs'),
          const SizedBox(width: 8),
          _filterChip('Pending'),
          const SizedBox(width: 8),
          _filterChip('In Progress'),
          const SizedBox(width: 8),
          _filterChip('Completed'),
          const SizedBox(width: 8),
          _filterChip('Disputed'),
          const SizedBox(width: 8),
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
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AdminColors.primary.withValues(alpha: 0.5) : AdminColors.borderDark),
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
