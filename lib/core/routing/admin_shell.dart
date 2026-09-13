import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../theme/app_colors.dart';

class AdminShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminShell({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, color: AppColors.primaryAction, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Zovio Admin',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      _buildNavItem(context, Icons.dashboard_outlined, 'Dashboard', 0),
                      _buildNavItem(context, Icons.people_outline, 'Workers', 1),
                      _buildNavItem(context, Icons.category_outlined, 'Services', 2),
                      _buildNavItem(context, Icons.location_city_outlined, 'Locations', 3),
                      _buildNavItem(context, Icons.book_online_outlined, 'Bookings', 4),
                      _buildNavItem(context, Icons.report_problem_outlined, 'Complaints', 5),
                      _buildNavItem(context, Icons.settings_outlined, 'Settings', 6),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      context.go(AppRoutes.welcome);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Vertical Divider
          Container(width: 1, color: AppColors.border),
          // Main Content
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = navigationShell.currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAction.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryAction : AppColors.textSecondary,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryAction : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => _goBranch(index),
      ),
    );
  }
}
