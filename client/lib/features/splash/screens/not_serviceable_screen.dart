import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class NotServiceableScreen extends ConsumerWidget {
  const NotServiceableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Serviceable'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 80, color: AppColors.error),
              const SizedBox(height: 24),
              Text(
                'We are not available in your area yet!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We are currently expanding our service areas. Please check back later.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).checkLocation();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Check Again'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                child: const Text('Logout', style: TextStyle(color: AppColors.error)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
