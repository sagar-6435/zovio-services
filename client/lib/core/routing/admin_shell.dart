import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

final adminSidebarProvider = StateProvider<bool>((ref) => true);

class AdminShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AdminShell({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSidebarOpen = ref.watch(adminSidebarProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          
          if (isMobile) {
            return Stack(
              children: [
                navigationShell,
                if (isSidebarOpen)
                  GestureDetector(
                    onTap: () => ref.read(adminSidebarProvider.notifier).state = false,
                    child: Container(color: Colors.black54),
                  ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: isSidebarOpen ? 0 : -250,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 250,
                    color: AppColors.white,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: _buildSidebarContent(context, ref),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Desktop Layout
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSidebarOpen ? 250 : 0,
                color: AppColors.white,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 250,
                    height: MediaQuery.of(context).size.height,
                    child: _buildSidebarContent(context, ref),
                  ),
                ),
              ),
              Container(width: 1, color: AppColors.border),
              Expanded(child: navigationShell),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              const Icon(Icons.admin_panel_settings, color: AppColors.primaryAction, size: 32),
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
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.welcome);
              }
            },
          ),
        ),
      ],
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
