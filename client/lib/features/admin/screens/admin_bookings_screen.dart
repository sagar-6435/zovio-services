import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';

class AdminBookingsScreen extends ConsumerWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ref.read(adminSidebarProvider.notifier).update((state) => !state);
          },
        ),
        title: const Text('Booking Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
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
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Recent Bookings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by ID or customer...',
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
                    DataColumn(label: Text('Booking ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Worker', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Service', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildBookingRow('B-4321', 'Ravi Verma', 'Rahul Sharma', 'Plumbing', 'Oct 12, 2023', '\$45.00', 'Completed', Colors.green),
                    _buildBookingRow('B-4322', 'Pooja Singh', 'Amit Kumar', 'Electrician', 'Oct 13, 2023', '\$120.00', 'In Progress', Colors.blue),
                    _buildBookingRow('B-4323', 'Sunil Das', 'Pending', 'Cleaning', 'Oct 14, 2023', '\$30.00', 'Pending', Colors.orange),
                    _buildBookingRow('B-4324', 'Neha Gupta', 'Vikram Singh', 'AC Repair', 'Oct 12, 2023', '\$85.00', 'Cancelled', Colors.red),
                    _buildBookingRow('B-4325', 'Rajesh K.', 'Priya Singh', 'Cleaning', 'Oct 11, 2023', '\$25.00', 'Completed', Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildBookingRow(String id, String customer, String worker, String service, String date, String amount, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryAction))),
        DataCell(Text(customer)),
        DataCell(Text(worker, style: TextStyle(color: worker == 'Pending' ? Colors.grey : AppColors.textPrimary, fontStyle: worker == 'Pending' ? FontStyle.italic : FontStyle.normal))),
        DataCell(Text(service)),
        DataCell(Text(date)),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.w500))),
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
          TextButton(
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
      ],
    );
  }
}
