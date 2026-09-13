import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminComplaintsScreen extends StatelessWidget {
  const AdminComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complaint Management'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Support Tickets',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: 'All',
                          items: <String>['All', 'Open', 'In Progress', 'Resolved'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                          underline: const SizedBox(),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search tickets...',
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
                  ],
                ),
              ),
              const Divider(height: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(AppColors.background),
                  columns: const [
                    DataColumn(label: Text('Ticket ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Issue Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildTicketRow('T-1001', 'Ravi Verma', 'Customer', 'Payment Issue', 'Oct 14, 2023', 'Open', Colors.red),
                    _buildTicketRow('T-1002', 'Amit Kumar', 'Worker', 'App Bug', 'Oct 14, 2023', 'In Progress', Colors.orange),
                    _buildTicketRow('T-1003', 'Neha Gupta', 'Customer', 'Worker No Show', 'Oct 13, 2023', 'Open', Colors.red),
                    _buildTicketRow('T-1004', 'Pooja Singh', 'Customer', 'Quality of Service', 'Oct 12, 2023', 'Resolved', Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildTicketRow(String id, String user, String role, String issue, String date, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryAction))),
        DataCell(Text(user)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: role == 'Customer' ? Colors.blue.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              role,
              style: TextStyle(
                color: role == 'Customer' ? Colors.blue : Colors.purple,
                fontSize: 10,
              ),
            ),
          ),
        ),
        DataCell(Text(issue)),
        DataCell(Text(date)),
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
            child: const Text('View Ticket'),
          ),
        ),
      ],
    );
  }
}
