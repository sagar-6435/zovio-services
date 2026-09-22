import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Badge style variations
enum ZovioBadgeStyle {
  /// Trust badge: Light teal background with teal text
  trust,

  /// Location badge: Soft orange background with orange text
  location,

  /// Custom: Use provided colors
  custom,
}

/// A Zovio-branded badge widget with rounded pill shape.
/// 
/// Supports different badge styles and custom colors.
/// Example:
/// ```dart
/// ZovioBadge(
///   label: '✦ TRUSTED AROUND YOU',
///   style: ZovioBadgeStyle.trust,
/// )
/// ```
class ZovioBadge extends StatelessWidget {
  /// The badge text label
  final String label;

  /// The badge style variant
  final ZovioBadgeStyle style;

  /// Background color (used when style is custom)
  final Color? backgroundColor;

  /// Text color (used when style is custom)
  final Color? textColor;

  /// Horizontal padding
  final EdgeInsets padding;

  const ZovioBadge({
    super.key,
    required this.label,
    this.style = ZovioBadgeStyle.trust,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  /// Get background color based on style
  Color _getBackgroundColor() {
    switch (style) {
      case ZovioBadgeStyle.trust:
        return AppColors.trustBadge;
      case ZovioBadgeStyle.location:
        return AppColors.softOrange;
      case ZovioBadgeStyle.custom:
        return backgroundColor ?? AppColors.trustBadge;
    }
  }

  /// Get text color based on style
  Color _getTextColor() {
    switch (style) {
      case ZovioBadgeStyle.trust:
        return AppColors.trustBadgeText;
      case ZovioBadgeStyle.location:
        return AppColors.primaryAction;
      case ZovioBadgeStyle.custom:
        return textColor ?? AppColors.trustBadgeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20), // Pill shape
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
