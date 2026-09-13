import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminWorkersScreen extends StatelessWidget {
  const AdminWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Worker Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Worker'),
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
                      'All Workers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search workers...',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
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
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Service', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildWorkerRow('W001', 'Rahul Sharma', 'Plumbing', 'South Delhi', 'Approved', Colors.green),
                    _buildWorkerRow('W002', 'Amit Kumar', 'Electrician', 'Gurgaon', 'Pending', Colors.orange),
                    _buildWorkerRow('W003', 'Priya Singh', 'Cleaning', 'Noida', 'Approved', Colors.green),
                    _buildWorkerRow('W004', 'Suresh Patel', 'Carpentry', 'East Delhi', 'Rejected', Colors.red),
                    _buildWorkerRow('W005', 'Vikram Singh', 'AC Repair', 'South Delhi', 'Approved', Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildWorkerRow(String id, String name, String service, String location, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryAction.withOpacity(0.1),
                child: Text(name[0], style: const TextStyle(color: AppColors.primaryAction, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
        ),
        DataCell(Text(service)),
        DataCell(Text(location)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == 'Pending') ...[
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  tooltip: 'Approve',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  tooltip: 'Reject',
                  onPressed: () {},
                ),
              ] else ...[
                TextButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
