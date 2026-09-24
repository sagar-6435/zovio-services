import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/api_client.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiClient.getServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 6 : (MediaQuery.of(context).size.width > 600 ? 4 : 3),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 120,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              IconData iconData = Icons.category;
              if (service['icon'] == 'cleaning') iconData = Icons.cleaning_services;
              else if (service['icon'] == 'plumbing') iconData = Icons.plumbing;
              else if (service['icon'] == 'electrical') iconData = Icons.electrical_services;
              else if (service['icon'] == 'painting') iconData = Icons.format_paint;
              
              return InkWell(
                onTap: () {
                  final catName = service['name'] ?? '';
                  context.push('${AppRoutes.customerWorkers}?filter=$catName');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        iconData,
                        size: 32,
                        color: AppColors.primaryAction,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service['name'] ?? 'Service',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }
}
