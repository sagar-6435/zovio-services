import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';
import '../../../providers/admin_providers.dart';
import '../../../services/api_client.dart';

class AdminServicesScreen extends ConsumerWidget {
  const AdminServicesScreen({super.key});

  void _showServiceDialog(BuildContext context, WidgetRef ref, [Map<String, dynamic>? service]) {
    final nameController = TextEditingController(text: service?['name'] ?? '');
    final descController = TextEditingController(text: service?['description'] ?? '');
    bool isActive = service?['isActive'] ?? true;
    
    // We will just let them type an icon name for now to keep it simple
    final iconController = TextEditingController(text: service?['icon'] ?? 'category');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(service == null ? 'Add Service' : 'Edit Service'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Service Name'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: iconController,
                      decoration: const InputDecoration(labelText: 'Icon Name (e.g. cleaning_services)'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Is Active'),
                        Switch(
                          value: isActive,
                          onChanged: (val) => setState(() => isActive = val),
                          activeColor: AppColors.primaryAction,
                        ),
                      ],
                    ),
                    // For simplicity, we are skipping multi-location select in this dialog 
                    // and assuming the service is available globally. In a real app we'd fetch 
                    // locations and show checkboxes.
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) return;
                    
                    final data = {
                      'name': nameController.text,
                      'description': descController.text,
                      'icon': iconController.text,
                      'isActive': isActive,
                      'locations': [], // Optional: add multi-select for locations here
                    };

                    try {
                      if (service == null) {
                        await apiClient.createService(data);
                      } else {
                        await apiClient.updateService(service['_id'], data);
                      }
                      ref.invalidate(servicesProvider);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      print('Error saving service: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAction,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ref.read(adminSidebarProvider.notifier).update((state) => !state);
          },
        ),
        title: const Text('Services Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showServiceDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Service'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Services & Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            servicesAsync.when(
              data: (services) {
                if (services.isEmpty) {
                  return const Center(child: Text('No services found.'));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 5;
                    if (constraints.maxWidth < 600) crossAxisCount = 2;
                    else if (constraints.maxWidth < 900) crossAxisCount = 3;
                    else if (constraints.maxWidth < 1200) crossAxisCount = 4;

                    return GridView.builder(
                      itemCount: services.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 180,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildServiceCard(context, ref, services[index]);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, WidgetRef ref, Map<String, dynamic> service) {
    bool isActive = service['isActive'] ?? true;
    IconData iconData = Icons.category;
    // Map string icons to IconData if needed, otherwise fallback to category.
    if (service['icon'] == 'cleaning_services') iconData = Icons.cleaning_services;
    if (service['icon'] == 'plumbing') iconData = Icons.plumbing;
    if (service['icon'] == 'electrical_services') iconData = Icons.electrical_services;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryAction.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: AppColors.primaryAction, size: 24),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isActive,
                  onChanged: (val) async {
                    await apiClient.updateService(service['_id'], {'isActive': val});
                    ref.invalidate(servicesProvider);
                  },
                  activeThumbColor: AppColors.primaryAction,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            service['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            service['description'] ?? 'No description',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => _showServiceDialog(context, ref, service),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                child: const Text('Edit'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await apiClient.deleteService(service['_id']);
                  ref.invalidate(servicesProvider);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
