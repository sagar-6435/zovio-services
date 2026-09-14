import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_service_card.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    // Mock data for services related to the given serviceId
    final mockServices = [
      {
        'name': 'Basic Cleaning ($serviceId)',
        'description': 'Standard cleaning for your home.',
        'rating': 4.5,
        'reviewCount': 89,
        'price': 'From \$40',
      },
      {
        'name': 'Deep Cleaning',
        'description': 'Thorough cleaning including hard-to-reach areas.',
        'rating': 4.8,
        'reviewCount': 156,
        'price': 'From \$80',
      },
      {
        'name': 'Move-in/Move-out',
        'description': 'Complete cleaning for empty homes.',
        'rating': 4.9,
        'reviewCount': 201,
        'price': 'From \$120',
      },
      {
        'name': 'Post-Construction',
        'description': 'Heavy duty cleaning after renovation.',
        'rating': 4.7,
        'reviewCount': 64,
        'price': 'From \$150',
      },
      {
        'name': 'Sanitization',
        'description': 'Disinfection and sanitization services.',
        'rating': 4.6,
        'reviewCount': 112,
        'price': 'From \$60',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Services - $serviceId'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: mockServices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final service = mockServices[index];
          return SizedBox(
            height: 160,
            child: ZovioServiceCard(
              serviceName: service['name'] as String,
              description: service['description'] as String,
              rating: service['rating'] as double,
              reviewCount: service['reviewCount'] as int,
              price: service['price'] as String,
              onTap: () {
                final encodedFilter = Uri.encodeComponent(service['name'] as String);
                context.push('${AppRoutes.customerWorkers}?filter=\$encodedFilter');
              },
            ),
          );
        },
      ),
    );
  }
}
