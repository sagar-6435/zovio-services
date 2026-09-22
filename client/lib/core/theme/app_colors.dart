import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // ZOVIO BRAND COLOR SYSTEM
  // ============================================================================
  // Primary Brand Colors
  static const Color cream = Color(0xFFFCF6E9);
  static const Color navy = Color(0xFF0D1B2E);
  static const Color orange = Color(0xFFE95A00);
  static const Color teal = Color(0xFF009C98);
  static const Color lightTeal = Color(0xFFA7E8E1);
  static const Color softOrange = Color(0xFFFCE9D3);

  // ============================================================================
  // BACKGROUND & SURFACE
  // ============================================================================
  static const Color background = Color(0xFFFCF6E9); // Warm cream background
  static const Color surface = Color(0xFFFFFFFF); // White cards/surfaces

  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  static const Color textPrimary = Color(0xFF0D1B2E); // Dark navy - main text
  static const Color textSecondary = Color(0xFF526579); // Secondary navy/slate
  static const Color textTertiary = Color(0xFF526579); // Muted text

  // ============================================================================
  // ACCENT & ACTION COLORS
  // ============================================================================
  static const Color primaryAction = Color(0xFFE95A00); // Primary CTA - orange
  static const Color secondaryAction = Color(0xFF009C98); // Trust/secondary - teal
  static const Color trustBadge = Color(0xFFA7E8E1); // Light teal badges
  static const Color trustBadgeText = Color(0xFF009C98); // Teal text for badges

  // ============================================================================
  // STATUS COLORS
  // ============================================================================
  static const Color success = Color(0xFF238636);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF009C98); // Using teal for info

  // ============================================================================
  // BORDERS & DIVIDERS
  // ============================================================================
  static const Color border = Color(0xFFE8DDCC); // Soft border
  static const Color divider = Color(0xFFF5EEDF); // Muted background
  static const Color mutedBackground = Color(0xFFF5EEDF);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================
  static const Color disabled = Color(0xFFD1D5DB);
  static const Color white = Color(0xFFFFFFFF);

  // ============================================================================
  // DEPRECATED: Kept for compatibility, use specific colors above
  // ============================================================================
  @Deprecated('Use primaryAction instead')
  static const Color primary = orange;
  @Deprecated('Use secondaryAction instead')
  static const Color secondary = teal;

  AppColors._();
}
