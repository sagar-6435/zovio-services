import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_app_bar.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/routing/route_names.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.name ?? 'Guest User';
    final userEmail = authState.email ?? authState.mobile ?? 'No email provided';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ZovioAppBar(
        title: 'Profile',
        showBackButton: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryAction.withOpacity(0.1),
                            border: Border.all(color: AppColors.primaryAction, width: 2),
                          ),
                          child: const Icon(Icons.person, size: 50, color: AppColors.primaryAction),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryAction,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: AppColors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(context, '12', 'Bookings'),
                    Container(height: 40, width: 1, color: AppColors.border),
                    _buildStatColumn(context, '4', 'Reviews'),
                    Container(height: 40, width: 1, color: AppColors.border),
                    _buildStatColumn(context, '3', 'Saved'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Menu Items
              Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    _buildMenuItem(context, Icons.person_outline, 'Edit Profile', onTap: () {
                      context.push(AppRoutes.customerEditProfile);
                    }),
                    _buildMenuItem(context, Icons.payment_outlined, 'Payment Methods', onTap: () {}),
                    _buildMenuItem(context, Icons.bookmark_outline, 'Saved Workers', onTap: () {
                      context.push(AppRoutes.customerSavedWorkers);
                    }),
                    _buildMenuItem(context, Icons.settings_outlined, 'Settings', onTap: () {
                      context.push(AppRoutes.customerSettings);
                    }),
                    _buildMenuItem(context, Icons.help_outline, 'Help & Support', onTap: () {
                      context.push(AppRoutes.customerSupport);
                    }),
                    const Divider(height: 1, color: AppColors.border),
                    _buildMenuItem(
                      context,
                      Icons.logout,
                      'Log Out',
                      textColor: AppColors.error,
                      iconColor: AppColors.error,
                      onTap: () {
                        ref.read(authProvider.notifier).logout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAction),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    Color? textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
    );
  }
}
