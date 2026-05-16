import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      color: AdminColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.black.withValues(alpha: 0.02),
                ),
                dataRowColor: WidgetStateProperty.all(Colors.transparent),
                headingTextStyle: const TextStyle(
                  color: AdminColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
                dataTextStyle: const TextStyle(
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
