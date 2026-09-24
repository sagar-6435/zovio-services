import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';
import '../../../providers/admin_providers.dart';
import '../../../services/api_client.dart';

class AdminWorkersScreen extends ConsumerWidget {
  const AdminWorkersScreen({super.key});

  void _showWorkerDialog(BuildContext context, WidgetRef ref, [Map<String, dynamic>? worker]) {
    final nameController = TextEditingController(text: worker?['name'] ?? '');
    String role = worker?['role'] ?? '';
    String status = worker?['status'] ?? 'Pending';
    final servicesFuture = apiClient.getServices();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(worker == null ? 'Add Worker' : 'Edit Worker'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Worker Name'),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<dynamic>>(
                      future: servicesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final services = snapshot.data ?? [];
                        final serviceNames = services.map((s) => s['name'] as String).toList();
                        final selectedRoles = role.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                        
                        for (final r in selectedRoles) {
                          if (!serviceNames.contains(r)) {
                            serviceNames.add(r);
                          }
                        }

                        return InkWell(
                          onTap: () async {
                            final selected = await showDialog<List<String>>(
                              context: context,
                              builder: (ctx) {
                                return _MultiSelectDialog(
                                  items: serviceNames,
                                  initialSelectedItems: selectedRoles,
                                );
                              },
                            );
                            if (selected != null) {
                              setState(() {
                                role = selected.join(', ');
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Role / Services',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                            child: Text(
                              selectedRoles.isEmpty ? 'Select Services' : selectedRoles.join(', '),
                              style: TextStyle(
                                color: selectedRoles.isEmpty ? Colors.grey : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ['Pending', 'Approved', 'Rejected', 'Inactive']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) => setState(() => status = val!),
                    ),
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
                    if (nameController.text.isEmpty || role.isEmpty) return;
                    
                    final data = {
                      'name': nameController.text,
                      'role': role,
                      'status': status,
                      'imageUrl': worker?['imageUrl'] ?? 'https://via.placeholder.com/150', // Mock image
                    };

                    try {
                      if (worker == null) {
                        await apiClient.createWorker(data);
                      } else {
                        await apiClient.updateWorker(worker['_id'], data);
                      }
                      ref.invalidate(workersProvider);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      print('Error saving worker: $e');
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
    final workersAsync = ref.watch(workersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ref.read(adminSidebarProvider.notifier).update((state) => !state);
          },
        ),
        title: const Text('Worker Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showWorkerDialog(context, ref),
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
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'All Workers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
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
              workersAsync.when(
                data: (workers) {
                  if (workers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('No workers found.')),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(AppColors.background),
                      columns: const [
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Service', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: workers.map<DataRow>((w) {
                        return _buildWorkerRow(context, ref, w);
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, st) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildWorkerRow(BuildContext context, WidgetRef ref, Map<String, dynamic> worker) {
    String status = worker['status'] ?? 'Pending';
    Color statusColor = Colors.orange;
    if (status == 'Approved') statusColor = Colors.green;
    if (status == 'Rejected') statusColor = Colors.red;
    if (status == 'Inactive') statusColor = Colors.grey;
    String name = worker['name'] ?? 'Unknown';

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryAction.withOpacity(0.1),
                child: Text(name.isNotEmpty ? name[0] : 'U', style: const TextStyle(color: AppColors.primaryAction, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
        ),
        DataCell(Text(worker['role'] ?? 'Unknown')),
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
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                tooltip: 'Edit',
                onPressed: () => _showWorkerDialog(context, ref, worker),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
                onPressed: () async {
                  await apiClient.deleteWorker(worker['_id']);
                  ref.invalidate(workersProvider);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedItems;

  const _MultiSelectDialog({required this.items, required this.initialSelectedItems});

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  final List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Services'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              value: _selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked == true) {
                    _selectedItems.add(item);
                  } else {
                    _selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAction,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, _selectedItems),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
