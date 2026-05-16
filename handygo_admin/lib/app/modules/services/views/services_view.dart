import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchServices();
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
        title: const Text('Delete Service'),
        content: const Text(
          'Are you sure you want to delete this service category?',
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
              style: TextStyle(color: AdminColors.error),
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
          backgroundColor: AdminColors.success,
          colorText: Colors.white,
        );
        _fetchServices();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete service',
          backgroundColor: AdminColors.error,
          colorText: Colors.white,
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

    Get.dialog(
      AlertDialog(
        title: Text(existing != null ? 'Edit Service' : 'Create New Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(nameCtrl, 'Service Name', Icons.build_outlined),
              const SizedBox(height: 12),
              _dialogField(categoryCtrl, 'Category', Icons.category_outlined),
              const SizedBox(height: 12),
              _dialogField(
                descCtrl,
                'Description',
                Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _dialogField(
                priceCtrl,
                'Base Price (₦)',
                Icons.payments_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _dialogField(
                iconCtrl,
                'Icon URL (optional)',
                Icons.image_outlined,
              ),
            ],
          ),
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
              existing != null ? 'Update' : 'Create',
              style: const TextStyle(color: Colors.white),
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
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
        backgroundColor: AdminColors.error,
        colorText: Colors.white,
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
          backgroundColor: AdminColors.success,
          colorText: Colors.white,
        );
      } else {
        await _api.post(AdminApiConstants.adminServices, data: data);
        Get.snackbar(
          'Success',
          'Service created',
          backgroundColor: AdminColors.success,
          colorText: Colors.white,
        );
      }
      Get.back();
      _fetchServices();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save service',
        backgroundColor: AdminColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      _error!,
                      style: const TextStyle(color: AdminColors.error),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchServices,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else
              GlassDataTable(
                title: 'Service Categories',
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
                    '${_services.length} Services',
                    style: const TextStyle(
                      color: AdminColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                rows: _services
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            StatusChip(
                              label:
                                  (s['is_active'] == true ||
                                      s['is_active'] == 1)
                                  ? 'Active'
                                  : 'Inactive',
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                _actionIcon(
                                  Icons.edit_rounded,
                                  AdminColors.accent,
                                  'Edit',
                                  () => _showCreateEditDialog(existing: s),
                                ),
                                const SizedBox(width: 8),
                                _actionIcon(
                                  Icons.delete_rounded,
                                  AdminColors.error,
                                  'Delete',
                                  () => _deleteService(s['id']),
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
            Text(
              'Services & Categories',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage the service categories available on HandyGo',
              style: TextStyle(color: AdminColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreateEditDialog(),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Service'),
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

  Widget _actionIcon(
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
