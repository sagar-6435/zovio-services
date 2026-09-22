import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A Zovio-branded card with rounded corners, soft borders, and minimal shadows.
/// 
/// Follows Zovio's premium design language with white background,
/// soft borders, and comfortable padding.
/// 
/// Example:
/// ```dart
/// ZovioCard(
///   child: Text('Your content here'),
///   onTap: () => print('Tapped!'),
/// )
/// ```
class ZovioCard extends StatelessWidget {
  /// The card content
  final Widget child;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Custom border radius (default: 16px)
  final BorderRadius? borderRadius;

  /// Custom border color (default: soft border)
  final Color borderColor;

  /// Custom padding (default: 16px all)
  final EdgeInsets padding;

  /// Show subtle shadow (default: true)
  final bool showShadow;

  /// Background color (default: white)
  final Color backgroundColor;

  const ZovioCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.borderColor = AppColors.border,
    this.padding = const EdgeInsets.all(16),
    this.showShadow = true,
    this.backgroundColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);

    final card = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: card,
        ),
      );
    }

    return card;
  }
}
