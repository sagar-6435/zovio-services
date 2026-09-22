import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

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
        title: const Text('Admin Dashboard & Analytics'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final isTablet = constraints.maxWidth > 600 && !isDesktop;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 24),
                if (isDesktop || isTablet)
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard(context, 'Total Users', '12,450', Icons.people, Colors.blue)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricCard(context, 'Active Workers', '842', Icons.engineering, AppColors.primaryAction)),
                      if (isDesktop) ...[
                        const SizedBox(width: 16),
                        Expanded(child: _buildMetricCard(context, 'Total Bookings', '4,320', Icons.book_online, Colors.green)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMetricCard(context, 'Total Revenue', '\$124,500', Icons.attach_money, Colors.orange)),
                      ]
                    ],
                  ),
                if (isTablet) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard(context, 'Total Bookings', '4,320', Icons.book_online, Colors.green)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricCard(context, 'Total Revenue', '\$124,500', Icons.attach_money, Colors.orange)),
                    ],
                  )
                ],
                if (!isDesktop && !isTablet) ...[
                  _buildMetricCard(context, 'Total Users', '12,450', Icons.people, Colors.blue),
                  const SizedBox(height: 16),
                  _buildMetricCard(context, 'Active Workers', '842', Icons.engineering, AppColors.primaryAction),
                  const SizedBox(height: 16),
                  _buildMetricCard(context, 'Total Bookings', '4,320', Icons.book_online, Colors.green),
                  const SizedBox(height: 16),
                  _buildMetricCard(context, 'Total Revenue', '\$124,500', Icons.attach_money, Colors.orange),
                ],
                const SizedBox(height: 32),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildChartPlaceholder(context, 'Revenue Trends', 300),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRecentActivity(context),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildChartPlaceholder(context, 'Revenue Trends', 300),
                      const SizedBox(height: 24),
                      _buildRecentActivity(context),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(BuildContext context, String title, double height) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Spacer(),
          const Center(child: Text('Chart Placeholder', style: TextStyle(color: AppColors.textSecondary))),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
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
          const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          _buildActivityItem('New worker signed up', '2 mins ago'),
          _buildActivityItem('Booking #432 completed', '15 mins ago'),
          _buildActivityItem('New complaint raised', '1 hour ago'),
          _buildActivityItem('Service "Plumbing" updated', '3 hours ago'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String text, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.primaryAction,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(color: AppColors.textPrimary)),
                Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
