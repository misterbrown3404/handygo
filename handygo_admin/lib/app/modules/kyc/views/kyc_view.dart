import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
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
        _verifiedCount = _requests
            .where((r) => r['status'] == 'approved')
            .length;
        _rejectedCount = _requests
            .where((r) => r['status'] == 'rejected')
            .length;
      }
    } catch (e) {
      _error = 'Failed to load KYC submissions';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _approveKyc(int id) async {
    try {
      await _api.post(AdminApiConstants.approveKyc(id));
      Get.snackbar(
        'Success',
        'KYC approved',
        backgroundColor: AdminColors.accent,
        colorText: AdminColors.white,
      );
      _fetchKyc();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve KYC',
        backgroundColor: AdminColors.danger,
        colorText: AdminColors.white,
      );
    }
  }

  Future<void> _rejectKyc(int id) async {
    try {
      await _api.post(
        AdminApiConstants.rejectKyc(id),
        data: {'rejection_reason': 'Documents invalid'},
      );
      Get.snackbar(
        'Success',
        'KYC rejected',
        backgroundColor: AdminColors.warning,
        colorText: AdminColors.white,
      );
      _fetchKyc();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject KYC',
        backgroundColor: AdminColors.danger,
        colorText: AdminColors.white,
      );
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
                            style: AdminTextStyles.bodyWith(
                              AdminColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AdminSpacing.sm),
                          ElevatedButton(
                            onPressed: _fetchKyc,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AdminSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KYC Verification',
                                    style: AdminTextStyles.h1,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Review and approve worker identity documents (NIN & BVN)',
                                    style: AdminTextStyles.bodySmallSecondary,
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: _fetchKyc,
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 18,
                              ),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AdminSpacing.lg),
                        _kycStats(context),
                        const SizedBox(height: AdminSpacing.lg),
                        _requests.isEmpty
                            ? GlassCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_user_outlined,
                                      size: 56,
                                      color: AdminColors.textSecondary
                                          .withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(height: AdminSpacing.sm),
                                    Text(
                                      'No KYC submissions yet',
                                      style: AdminTextStyles.h3,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'New submissions will appear here automatically.',
                                      style: AdminTextStyles.bodySmallSecondary,
                                    ),
                                  ],
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
                                  final name =
                                      r['user']?['name'] ??
                                      r['worker']?['name'] ??
                                      'Unknown';
                                  final docType =
                                      r['document_type'] ?? 'NIN';
                                  final docNumber =
                                      r['document_number'] ?? '***';
                                  final date =
                                      _formatDate(r['created_at'] ?? '');
                                  final status = _capitalize(
                                    r['status'] ?? 'pending',
                                  );
                                  final id = r['id'];
                                  // Mask NIN: show only last 4
                                  final maskedNIN = docNumber.length > 4
                                      ? '****${docNumber.substring(docNumber.length - 4)}'
                                      : docNumber;

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  const Color(
                                                    0xFFe3f9f0,
                                                  ),
                                              child: Text(
                                                name[0],
                                                style: const TextStyle(
                                                  color: AdminColors.accent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          docType.toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                'Menlo, Consolas, monospace',
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          maskedNIN,
                                          style: const TextStyle(
                                            fontFamily: 'Menlo, Consolas, monospace',
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(date),
                                      ),
                                      DataCell(StatusChip(label: status)),
                                      DataCell(
                                        r['status'] == 'pending'
                                            ? Row(
                                                children: [
                                                  _actionBtn(
                                                    'Approve',
                                                    AdminColors.accent,
                                                    () => _approveKyc(id),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  _actionBtn(
                                                    'Reject',
                                                    AdminColors.danger,
                                                    () => _rejectKyc(id),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
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

  String _formatDate(String raw) {
    if (raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // ── Stats (Wrap on mobile, Row on desktop) ────────────────────

  Widget _kycStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final stats = [
          _KycStatData(
            label: 'Pending Review',
            value: '$_pendingCount',
            color: AdminColors.warning,
            icon: Icons.hourglass_top_rounded,
            lightColor: AdminColors.warningLight,
          ),
          _KycStatData(
            label: 'Verified',
            value: '$_verifiedCount',
            color: AdminColors.accent,
            icon: Icons.verified_rounded,
            lightColor: AdminColors.accentLight,
          ),
          _KycStatData(
            label: 'Rejected',
            value: '$_rejectedCount',
            color: AdminColors.danger,
            icon: Icons.cancel_rounded,
            lightColor: AdminColors.dangerLight,
          ),
        ];
        if (isMobile) {
          return Wrap(
            spacing: AdminSpacing.sm,
            runSpacing: AdminSpacing.sm,
            children: stats
                .map(
                  (s) => SizedBox(
                    width: (constraints.maxWidth - 2 * AdminSpacing.xl -
                        AdminSpacing.sm) /
                        2,
                    child: _buildStatCard(s),
                  ),
                )
                .toList(),
          );
        }
        return Row(
          children:
              stats
                  .map(
                    (s) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: stats.last == s
                              ? 0
                              : AdminSpacing.sm,
                        ),
                        child: _buildStatCard(s),
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildStatCard(_KycStatData s) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AdminSpacing.sm),
            decoration: BoxDecoration(
              color: s.lightColor,
              borderRadius: BorderRadius.circular(AdminSpacing.sm),
            ),
            child: Icon(s.icon, color: s.color, size: 20),
          ),
          const SizedBox(width: AdminSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.value,
                style: TextStyle(
                  color: s.color,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                s.label,
                style: const TextStyle(
                  color: AdminColors.textSecondary,
                  fontSize: 12,
                ),
              ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AdminSpacing.sm,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AdminSpacing.sm),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _KycStatData {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final Color lightColor;
  const _KycStatData({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.lightColor,
  });
}
