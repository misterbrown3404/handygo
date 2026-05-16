import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';
import 'package:handygo_admin/app/core/widgets/glass_data_table.dart';
import 'package:handygo_admin/app/core/widgets/status_chip.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class KycView extends StatefulWidget {
  const KycView({super.key});

  @override
  State<KycView> createState() => _KycViewState();
}

class _KycViewState extends State<KycView> {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;
  String? _error;

  // Stats
  int _pendingCount = 0;
  int _verifiedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchKyc();
  }

  Future<void> _fetchKyc() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _api.get(AdminApiConstants.kyc);
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

        _requests = dataList.cast<Map<String, dynamic>>();
        _pendingCount = _requests.where((r) => r['status'] == 'pending').length;
        _verifiedCount = _requests.where((r) => r['status'] == 'approved').length;
        _rejectedCount = _requests.where((r) => r['status'] == 'rejected').length;
      }
    } catch (e) {
      _error = 'Failed to load KYC submissions';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _approveKyc(int id) async {
    try {
      await _api.post('/admin/kyc/$id/approve');
      Get.snackbar('Success', 'KYC approved', backgroundColor: AdminColors.success, colorText: Colors.white);
      _fetchKyc();
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve KYC', backgroundColor: AdminColors.error, colorText: Colors.white);
    }
  }

  Future<void> _rejectKyc(int id) async {
    try {
      await _api.post('/admin/kyc/$id/reject', data: {'rejection_reason': 'Documents invalid'}); // In a real app, use a dialog to get reason
      Get.snackbar('Success', 'KYC rejected', backgroundColor: AdminColors.warning, colorText: Colors.white);
      _fetchKyc();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject KYC', backgroundColor: AdminColors.error, colorText: Colors.white);
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
                      ElevatedButton(onPressed: _fetchKyc, child: const Text('Retry')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('KYC Verification', style: TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Review and approve worker identity documents (NIN & BVN)', style: TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: _fetchKyc,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _kycStats(context),
                      const SizedBox(height: 24),
                      _requests.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(Icons.verified_user_rounded, color: AdminColors.textSecondary.withValues(alpha: 0.3), size: 64),
                                    const SizedBox(height: 16),
                                    const Text('No KYC submissions yet', style: TextStyle(color: AdminColors.textSecondary, fontSize: 16)),
                                  ],
                                ),
                              ),
                            )
                          : GlassDataTable(
                              title: 'Verification Queue',
                              columns: const [
                                DataColumn(label: Text('WORKER')),
                                DataColumn(label: Text('TYPE')),
                                DataColumn(label: Text('DOCUMENT')),
                                DataColumn(label: Text('SUBMITTED')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTIONS')),
                              ],
                              rows: _requests.map((r) {
                                final name = r['user']?['name'] ?? r['worker']?['name'] ?? 'Unknown';
                                final docType = r['document_type'] ?? 'NIN';
                                final docNumber = r['document_number'] ?? '***';
                                final date = _formatDate(r['created_at'] ?? '');
                                final status = _capitalize(r['status'] ?? 'pending');
                                final id = r['id'];

                                return DataRow(cells: [
                                  DataCell(Row(children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AdminColors.warning.withValues(alpha: 0.15),
                                      child: Text(name[0], style: const TextStyle(color: AdminColors.warning, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ])),
                                  DataCell(Text(docType.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500))),
                                  DataCell(Text(docNumber, style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1))),
                                  DataCell(Text(date)),
                                  DataCell(StatusChip(label: status)),
                                  DataCell(
                                    r['status'] == 'pending'
                                        ? Row(children: [
                                            _actionBtn('Approve', AdminColors.success, () => _approveKyc(id)),
                                            const SizedBox(width: 8),
                                            _actionBtn('Reject', AdminColors.error, () => _rejectKyc(id)),
                                          ])
                                        : const SizedBox.shrink(),
                                  ),
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
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _kycStats(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      children: [
        if (isMobile) ...[
          _miniStat('Pending Review', '$_pendingCount', AdminColors.warning, Icons.hourglass_top_rounded),
          const SizedBox(height: 16),
          _miniStat('Verified', '$_verifiedCount', AdminColors.success, Icons.verified_rounded),
          const SizedBox(height: 16),
          _miniStat('Rejected', '$_rejectedCount', AdminColors.error, Icons.cancel_rounded),
        ] else ...[
          Expanded(child: _miniStat('Pending Review', '$_pendingCount', AdminColors.warning, Icons.hourglass_top_rounded)),
          const SizedBox(width: 16),
          Expanded(child: _miniStat('Verified', '$_verifiedCount', AdminColors.success, Icons.verified_rounded)),
          const SizedBox(width: 16),
          Expanded(child: _miniStat('Rejected', '$_rejectedCount', AdminColors.error, Icons.cancel_rounded)),
        ]
      ],
    );
  }

  Widget _miniStat(String label, String value, Color color, IconData icon) {
    return GlassCard(
      glowColor: color,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
