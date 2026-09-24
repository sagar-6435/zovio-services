import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';
import '../../../services/api_client.dart';

class AdminBookingsScreen extends ConsumerStatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  ConsumerState<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends ConsumerState<AdminBookingsScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);
    final data = await apiClient.getBookings();
    setState(() {
      _bookings = data;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(String id, String status) async {
    final success = await apiClient.updateBookingStatus(id, status);
    if (success) {
      _fetchBookings(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking $status successfully')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update booking status')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _fetchBookings,
                              tooltip: 'Refresh',
                            ),
                            const SizedBox(width: 8),
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
                        DataColumn(label: Text('Customer Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Worker', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _bookings.map((booking) {
                        final id = (booking['_id'] as String?) ?? '';
                        final shortId = id.length > 6 ? id.substring(id.length - 6).toUpperCase() : id;
                        final mobile = (booking['mobile'] as String?) ?? 'Unknown';
                        
                        final workerObj = booking['workerId'];
                        final workerName = workerObj != null ? workerObj['name'] ?? 'Worker' : 'Unassigned';
                        
                        final date = (booking['date'] as String?) ?? '';
                        final time = (booking['time'] as String?) ?? '';
                        final dateTime = '$date $time';
                        
                        final location = (booking['location'] as String?) ?? '';
                        final status = (booking['status'] as String?) ?? 'Pending';
                        
                        Color statusColor;
                        switch (status) {
                          case 'Completed': statusColor = Colors.green; break;
                          case 'Approved': statusColor = Colors.blue; break;
                          case 'Pending': statusColor = Colors.orange; break;
                          case 'Cancelled': 
                          case 'Rejected': statusColor = Colors.red; break;
                          default: statusColor = Colors.grey;
                        }

                        return DataRow(
                          cells: [
                            DataCell(Text(shortId, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryAction))),
                            DataCell(Text(mobile)),
                            DataCell(Text(workerName)),
                            DataCell(Text(dateTime)),
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
                              status == 'Pending' 
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => _updateStatus(id, 'Approved'),
                                      style: TextButton.styleFrom(foregroundColor: Colors.green),
                                      child: const Text('Approve'),
                                    ),
                                    TextButton(
                                      onPressed: () => _updateStatus(id, 'Rejected'),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Reject'),
                                    ),
                                  ],
                                )
                              : const Text('-'),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
