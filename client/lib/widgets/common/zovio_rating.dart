import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ZovioRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double? size;

  const ZovioRating({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 14.0;

    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.warning,
          size: size,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '($reviewCount)',
          style: TextStyle(
            fontSize: size - 2,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
