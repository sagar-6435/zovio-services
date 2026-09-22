import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_app_bar.dart';
import '../../../widgets/common/zovio_worker_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ZovioAppBar(
        title: 'Explore',
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for services or workers...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primaryAction, width: 2),
                    ),
                  ),
                ),
              ),

              // Trending Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Trending Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final categories = [
                      {'name': 'Cleaning', 'icon': Icons.cleaning_services},
                      {'name': 'Plumbing', 'icon': Icons.plumbing},
                      {'name': 'Electrical', 'icon': Icons.electrical_services},
                      {'name': 'Painting', 'icon': Icons.format_paint},
                      {'name': 'Moving', 'icon': Icons.local_shipping},
                    ];
                    return Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAction.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            categories[index]['icon'] as IconData,
                            size: 36,
                            color: AppColors.primaryAction,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categories[index]['name'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Services Near You (Map Placeholder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Workers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: AppColors.primaryAction),
                      child: const Text('View Map'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 180, // Consistent height with home screen fix
                    child: ZovioWorkerCard(
                      workerName: 'Pro Worker ${index + 1}',
                      specialization: 'Top Rated Professional',
                      rating: 4.5 + (index * 0.1),
                      reviewCount: 40 + (index * 12),
                      location: '${(index + 1) * 1.2} km away',
                      isAvailable: index % 2 == 0,
                      onTap: () {},
                      onContactPressed: () {},
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
