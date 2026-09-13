import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminServicesScreen extends StatelessWidget {
  const AdminServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Services Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAction,
                foregroundColor: Colors.white,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Services & Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildServiceCard('Cleaning', '124 Active Workers', Icons.cleaning_services, true),
                _buildServiceCard('Plumbing', '89 Active Workers', Icons.plumbing, true),
                _buildServiceCard('Electrician', '102 Active Workers', Icons.electrical_services, true),
                _buildServiceCard('Carpentry', '45 Active Workers', Icons.handyman, true),
                _buildServiceCard('AC Repair', '67 Active Workers', Icons.ac_unit, true),
                _buildServiceCard('Painting', '34 Active Workers', Icons.format_paint, false),
                _buildServiceCard('Pest Control', '12 Active Workers', Icons.bug_report, true),
                _buildServiceCard('Gardening', '0 Active Workers', Icons.yard, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String subtitle, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryAction.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryAction),
              ),
              Switch(
                value: isActive,
                onChanged: (val) {},
                activeThumbColor: AppColors.primaryAction,
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                child: const Text('Edit'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
