import 'package:flutter/material.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';

class GlassDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String? title;
  final Widget? trailing;

  const GlassDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AdminSpacing.lg,
                AdminSpacing.lg,
                AdminSpacing.lg,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: AdminTextStyles.h3,
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AdminSpacing.md),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              child: DataTable(
                headingRowColor:
                    const WidgetStatePropertyAll(AdminColors.borderDark),
                dataRowColor:
                    const WidgetStatePropertyAll(Colors.transparent),
                headingTextStyle: const TextStyle(
                  fontFamily: 'Inter',
                  color: AdminColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
                dataTextStyle: const TextStyle(
                  fontFamily: 'Inter',
                  color: AdminColors.textPrimary,
                  fontSize: 13,
                ),
                columnSpacing: 28,
                columns: columns,
                rows: rows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
