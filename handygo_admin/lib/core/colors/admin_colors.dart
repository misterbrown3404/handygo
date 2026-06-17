import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─── Palette ────────────────────────────────────────────────────

class AdminColors {
  // Surface neutral range
  static const Color neutral50    = Color(0xFFf9fafb);
  static const Color neutral100   = Color(0xFFf3f4f6);
  static const Color neutral200   = Color(0xFFe5e7eb);
  static const Color neutral400   = Color(0xFF9ca3af);
  static const Color neutral600   = Color(0xFF4b5563);
  static const Color neutral900   = Color(0xFF111827);

  // ─ Primary ───────────────────────────────────────────────────
  static const Color primary      = Color(0xFF1a56db); // Royal blue
  static const Color primaryDark  = Color(0xFF1e429f);
  /// 12 % opacity tint of primary — usable as a light backdrop / badge
  static // non-const: uses withValues() which is not const in this context
      final
      Color primaryLight = primary.withValues(alpha: 0.1);

  // ─ Accent ────────────────────────────────────────────────────
  static const Color accent       = Color(0xFF0e9f6e); // Success green
  /// 10 % opacity accent
  static // non-const
      final
      Color accentLight = accent.withValues(alpha: 0.1);

  // ─ Status ─────────────────────────────────────────────────────
  static const Color warning      = Color(0xFFe3a008); // Amber
  static final Color warningLight  = warning.withValues(alpha: 0.1);
  static const Color danger       = Color(0xFFe02424); // Red
  static final Color dangerLight   = danger.withValues(alpha: 0.1);

  // ─ Misc ───────────────────────────────────────────────────────
  static const Color white         = Color(0xFFffffff);
  static const Color black         = Color(0xFF000000);

  // ─ Backward-compat aliases used by existing views ─────────────
  static const Color secondary    = Color(0xFF64748B);
  static const Color success      = Color(0xFF0e9f6e);
  static const Color error        = Color(0xFFe02424);
  static const Color textPrimary  = Color(0xFF111827);
  static const Color textSecondary  = Color(0xFF4b5563);
  static const Color surface      = Color(0xFFffffff);
  static const Color background   = Color(0xFFf9fafb);
  static const Color borderDark   = Color(0xFFe5e7eb);
  static const Color cardDark     = Color(0xFFffffff);
  static const Color chart1       = Color(0xFF1a56db);
  static const Color chart2       = Color(0xFF0e9f6e);
  static const Color chart3       = Color(0xFFe3a008);
  static const Color chart4       = Color(0xFF1e429f);
}

/// ─── Spacing tokens (base unit = 4 px) ─────────────────────────

class AdminSpacing {
  static const double xs  = 8.0;
  static const double sm  = 12.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

/// ─── Typography ─────────────────────────────────────────────────

class AdminTextStyles {
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AdminColors.textPrimary,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AdminColors.textPrimary,
      );

  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AdminColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AdminColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AdminColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AdminColors.textPrimary,
      );

  static TextStyle captionWith(Color color, [FontWeight fw = FontWeight.w500]) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fw,
        color: color,
      );

  /// Monospace style for IDs, codes, job numbers.
  /// Falls back to monospace if Google-fonts menlo is not registered.
  static TextStyle get mono => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AdminColors.textPrimary,
      );

  // Convenience colour variants
  static TextStyle h1With(Color color) => h1.copyWith(color: color);
  static TextStyle h2With(Color color) => h2.copyWith(color: color);
  static TextStyle h3With(Color color) => h3.copyWith(color: color);
  static TextStyle bodyWith(Color color) =>
      body.copyWith(color: color, fontFamily: 'Inter');
  static TextStyle bodySmallWith(Color color) =>
      bodySmall.copyWith(color: color, fontFamily: 'Inter');

  // Pre-built commonly-used variants
  static TextStyle get bodySmallSecondary =>
      bodySmall.copyWith(color: AdminColors.textSecondary);
}

/// ─── Elevation ──────────────────────────────────────────────────

class AdminShadows {
  static final shadowXs = [
    BoxShadow(
      color: AdminColors.neutral900.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static final shadowSm = [
    BoxShadow(
      color: AdminColors.neutral900.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final shadowMd = [
    BoxShadow(
      color: AdminColors.neutral900.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final shadowLg = [
    BoxShadow(
      color: AdminColors.neutral900.withValues(alpha: 0.10),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static final shadowXl = [
    BoxShadow(
      color: AdminColors.neutral900.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}
