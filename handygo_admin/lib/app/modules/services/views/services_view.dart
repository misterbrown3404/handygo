import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class ServicesAdminView extends StatefulWidget {
  const ServicesAdminView({super.key});

  @override
  State<ServicesAdminView> createState() => _ServicesAdminViewState();
}

class _ServicesAdminViewState extends State<ServicesAdminView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.get(AdminApiConstants.services);
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        _services = data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      _error = 'Failed to load services';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteService(int id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AdminColors.surface,
        title: const Text(
          'Delete Service',
          style: TextStyle(color: AdminColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this service category?',
          style: TextStyle(color: AdminColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AdminColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _api.delete('${AdminApiConstants.adminServices}/$id');
        Get.snackbar(
          'Success',
          'Service deleted',
          backgroundColor: AdminColors.accent,
          colorText: AdminColors.white,
        );
        _fetchServices();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete service',
          backgroundColor: AdminColors.danger,
          colorText: AdminColors.white,
        );
      }
    }
  }

  void _showCreateEditDialog({Map<String, dynamic>? existing}) {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final categoryCtrl = TextEditingController(
      text: existing?['category'] ?? '',
    );
    final descCtrl = TextEditingController(
      text: existing?['description'] ?? '',
    );
    final priceCtrl = TextEditingController(
      text: existing?['base_price']?.toString() ?? '',
    );
    final iconCtrl = TextEditingController(text: existing?['icon'] ?? '');

    final isEdit = existing != null;
    Get.dialog(
      AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text(
          isEdit ? 'Edit Service' : 'Create New Service',
          style: const TextStyle(color: AdminColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(nameCtrl, 'Service Name', Icons.build_outlined),
              const SizedBox(height: AdminSpacing.sm),
              _dialogField(categoryCtrl, 'Category', Icons.category_outlined),
              const SizedBox(height: AdminSpacing.sm),
              _dialogField(
                descCtrl,
                'Description',
                Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: AdminSpacing.sm),
              _dialogField(
                priceCtrl,
                'Base Price (₦)',
                Icons.payments_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AdminSpacing.sm),
              _dialogField(
                iconCtrl,
                'Icon URL (optional)',
                Icons.image_outlined,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md,
          vertical: AdminSpacing.sm,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => _saveService(
              id: existing?['id'],
              name: nameCtrl.text,
              category: categoryCtrl.text,
              description: descCtrl.text,
              basePrice: priceCtrl.text,
              icon: iconCtrl.text,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.primary,
            ),
            child: Text(
              isEdit ? 'Update' : 'Create',
              style: const TextStyle(color: AdminColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AdminColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AdminColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminSpacing.sm),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.sm,
          vertical: AdminSpacing.xs + 2,
        ),
      ),
    );
  }

  Future<void> _saveService({
    int? id,
    required String name,
    required String category,
    required String description,
    required String basePrice,
    required String icon,
  }) async {
    if (name.isEmpty || category.isEmpty) {
      Get.snackbar(
        'Error',
        'Name and Category are required',
        backgroundColor: AdminColors.danger,
        colorText: AdminColors.white,
      );
      return;
    }

    final data = {
      'name': name,
      'category': category,
      'description': description,
      if (basePrice.isNotEmpty) 'base_price': double.tryParse(basePrice),
      if (icon.isNotEmpty) 'icon': icon,
    };

    try {
      if (id != null) {
        await _api.put('${AdminApiConstants.adminServices}/$id', data: data);
        Get.snackbar(
          'Success',
          'Service updated',
          backgroundColor: AdminColors.accent,
          colorText: AdminColors.white,
        );
      } else {
        await _api.post(AdminApiConstants.adminServices, data: data);
        Get.snackbar(
          'Success',
          'Service created',
          backgroundColor: AdminColors.accent,
          colorText: AdminColors.white,
        );
      }
      Get.back();
      _fetchServices();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save service',
        backgroundColor: AdminColors.danger,
        colorText: AdminColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _services
        : _services.where((s) {
            final name = (s['name'] ?? '').toString().toLowerCase();
            final cat = (s['category'] ?? '').toString().toLowerCase();
            return name.contains(query) || cat.contains(query);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AdminColors.primary),
              )
            : _error != null
                ? Center(
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
                            _error!,
                            style: const TextStyle(color: AdminColors.error),
                          ),
                          const SizedBox(height: AdminSpacing.sm),
                          ElevatedButton(
                            onPressed: _fetchServices,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : filtered.isEmpty
                    ? GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 56,
                              color: AdminColors.textSecondary
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AdminSpacing.sm),
                            Text(
                              'No services found',
                              style: AdminTextStyles.h3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _searchCtrl.text.isEmpty
                                  ? 'Create your first service category to get started.'
                                  : 'No service matches your search.',
                              style: AdminTextStyles.bodySmallSecondary,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(AdminSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header(),
                            const SizedBox(height: AdminSpacing.lg),
                            _buildSearchBar(context),
                            const SizedBox(height: AdminSpacing.lg),
                            GlassDataTable(
                              title: 'Service Categories',
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
                                  '${filtered.length} Services',
                                  style: const TextStyle(
                                    color: AdminColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              columns: const [
                                DataColumn(label: Text('NAME')),
                                DataColumn(label: Text('CATEGORY')),
                                DataColumn(label: Text('BASE PRICE')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTIONS')),
                              ],
                              rows: filtered
                                  .map(
                                    (s) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            s['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            s['category'] ?? '',
                                            style: const TextStyle(
                                              color: AdminColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            s['base_price'] != null
                                                ? '₦${s['base_price']}'
                                                : 'N/A',
                                            style: const TextStyle(
                                              color: AdminColors.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          StatusChip(
                                            label: (s['is_active'] == true ||
                                                    s['is_active'] == 1)
                                                ? 'Active'
                                                : 'Inactive',
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              _actionBtn(
                                                Icons.edit_rounded,
                                                AdminColors.accent,
                                                'Edit',
                                                () =>
                                                    _showCreateEditDialog(
                                                      existing: s,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              _actionBtn(
                                                Icons.delete_rounded,
                                                AdminColors.danger,
                                                'Delete',
                                                () =>
                                                    _deleteService(s['id']),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
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
              Text('Services & Categories', style: AdminTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Manage the service categories available on HandyGo',
                style: AdminTextStyles.bodySmallSecondary,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () => _showCreateEditDialog(),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Service'),
        ),
      ],
    );
  }

  // ── Search bar ────────────────────────────────────────────────

  Widget _buildSearchBar(BuildContext context) {
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
              style: const TextStyle(color: AdminColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search services...',
                hintStyle: TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
