import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'zovio_rating.dart';

class ZovioWorkerCard extends StatelessWidget {
  final String workerName;
  final String? specialization;
  final String? profileImageUrl;
  final double? rating;
  final int? reviewCount;
  final String? location;
  final bool? isAvailable;
  final VoidCallback? onTap;
  final VoidCallback? onContactPressed;

  const ZovioWorkerCard({
    super.key,
    required this.workerName,
    this.specialization,
    this.profileImageUrl,
    this.rating,
    this.reviewCount,
    this.location,
    this.isAvailable,
    this.onTap,
    this.onContactPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  // Worker Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workerName,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (specialization != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            specialization!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Availability Status
                  if (isAvailable != null)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAvailable! ? AppColors.success : AppColors.disabled,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Rating and Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (rating != null)
                    ZovioRating(
                      rating: rating!,
                      reviewCount: reviewCount ?? 0,
                      size: 11,
                    ),
                  if (location != null)
                    Expanded(
                      child: Text(
                        '📍 $location',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Contact Button
              if (onContactPressed != null)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onContactPressed,
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text(
                      'Contact',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAction,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
