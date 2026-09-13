import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminLocationsScreen extends StatelessWidget {
  const AdminLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Locations Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_location),
              label: const Text('Add Location'),
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
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Supported Cities & Zones',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(AppColors.background),
                  columns: const [
                    DataColumn(label: Text('City/Zone', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Active Workers', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildLocationRow('South Delhi', 'Delhi', '124', true),
                    _buildLocationRow('Gurgaon', 'Haryana', '89', true),
                    _buildLocationRow('Noida', 'Uttar Pradesh', '102', true),
                    _buildLocationRow('East Delhi', 'Delhi', '45', true),
                    _buildLocationRow('Faridabad', 'Haryana', '0', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildLocationRow(String city, String state, String workers, bool isActive) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primaryAction, size: 20),
              const SizedBox(width: 8),
              Text(city, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        DataCell(Text(state)),
        DataCell(Text(workers)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: isActive,
                onChanged: (val) {},
                activeThumbColor: AppColors.primaryAction,
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                tooltip: 'Edit',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
