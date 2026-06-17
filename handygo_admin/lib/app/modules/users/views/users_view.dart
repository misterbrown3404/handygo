import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _api.get(AdminApiConstants.customers);
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

        _customers = dataList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      _error = 'Failed to load customers';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filteredCustomers = _customers.where((u) {
      if (_selectedFilter != 'All') {
        final s = (u['status'] ?? 'active').toString().toLowerCase();
        if (s != _selectedFilter.toLowerCase()) return false;
      }
      if (query.isNotEmpty) {
        final name = (u['name'] ?? '').toString().toLowerCase();
        final email = (u['email'] ?? '').toString().toLowerCase();
        if (!name.contains(query) && !email.contains(query)) return false;
      }
      return true;
    }).toList();

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
                        if (filteredCustomers.isEmpty)
                          _noUsersEmpty()
                        else
                          GlassDataTable(
                            title: 'Customer Directory',
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AdminSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AdminColors.primaryLight,
                                borderRadius: BorderRadius.circular(
                                  AdminSpacing.xs,
                                ),
                              ),
                              child: Text(
                                '${filteredCustomers.length} Customers',
                                style: const TextStyle(
                                  color: AdminColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            columns: const [
                              DataColumn(label: Text('CUSTOMER')),
                              DataColumn(label: Text('PHONE')),
                              DataColumn(label: Text('EMAIL')),
                              DataColumn(label: Text('JOINED')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: filteredCustomers.map((u) {
                              final name = u['name'] ?? 'Unknown';
                              final email = u['email'] ?? '';
                              final phone = u['phone'] ?? '';
                              final joined = u['created_at'] ?? '';

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
                                      phone,
                                      style: const TextStyle(
                                        color: AdminColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        color: AdminColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      _formatDate(joined),
                                      style: const TextStyle(
                                        color: AdminColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        _actionIcon(
                                          Icons.visibility_rounded,
                                          AdminColors.textSecondary,
                                          'View Profile',
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
      ),
    );
  }

  // ── Empty / error helpers ──────────────────────────────────────

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
              textAlign: TextAlign.center,
              style: AdminTextStyles.bodyWith(AdminColors.textSecondary),
            ),
            const SizedBox(height: AdminSpacing.lg),
            ElevatedButton(onPressed: _fetchCustomers, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _noUsersEmpty() {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 56,
            color: AdminColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AdminSpacing.sm),
          Text('No users found', style: AdminTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            _searchCtrl.text.isEmpty
                ? 'There are no customers to display.'
                : 'Try adjusting your search or filter criteria.',
            style: AdminTextStyles.bodySmallSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
              Text('Customer Management', style: AdminTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Manage, monitor, and support registered customers',
                style: AdminTextStyles.bodySmallSecondary,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _fetchCustomers,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  // ── Search + filter row ────────────────────────────────────────

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
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(flex: 2, child: _buildSearchBox()),
        const SizedBox(width: AdminSpacing.lg),
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
          const SizedBox(width: AdminSpacing.sm - 2),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AdminColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search customers by name or email...',
                hintStyle: TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: AdminColors.borderDark,
          ),
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
      child: Row(
        children: ['All', 'Active', 'Pending', 'Suspended']
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
      borderRadius: BorderRadius.circular(AdminSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md,
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

  // ── Avatar & action helpers ────────────────────────────────────

  Widget _buildAvatar(String name) {
    final colors = [
      AdminColors.primary,
      AdminColors.accent,
      AdminColors.warning,
      AdminColors.chart4,
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

  String _formatDate(String raw) {
    if (raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
