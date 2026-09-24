import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/admin_shell.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/admin_providers.dart';
import '../../../services/api_client.dart';
import '../../../widgets/admin/location_picker_dialog.dart';

class AdminLocationsScreen extends ConsumerWidget {
  const AdminLocationsScreen({super.key});

  void _showLocationDialog(BuildContext context, WidgetRef ref, [Map<String, dynamic>? location]) {
    final cityController = TextEditingController(text: location?['city'] ?? '');
    final stateController = TextEditingController(text: location?['state'] ?? '');
    final latController = TextEditingController(text: location != null && location['latitude'] != null ? location['latitude'].toString() : '');
    final lngController = TextEditingController(text: location != null && location['longitude'] != null ? location['longitude'].toString() : '');
    final radiusController = TextEditingController(text: location != null && location['radius'] != null ? location['radius'].toString() : '5');
    bool isActive = location?['isActive'] ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(location == null ? 'Add Location' : 'Edit Location'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City/Zone'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: stateController,
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latController,
                            decoration: const InputDecoration(labelText: 'Latitude'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: lngController,
                            decoration: const InputDecoration(labelText: 'Longitude'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.map, color: AppColors.primaryAction),
                          tooltip: 'Pick on Map',
                          onPressed: () async {
                            final double? currentLat = double.tryParse(latController.text);
                            final double? currentLng = double.tryParse(lngController.text);
                            final initialLoc = (currentLat != null && currentLng != null)
                                ? LatLng(currentLat, currentLng)
                                : null;
                                
                            final LatLng? picked = await showDialog(
                              context: context,
                              builder: (context) => LocationPickerDialog(
                                initialLocation: initialLoc,
                              ),
                            );
                            if (picked != null) {
                              latController.text = picked.latitude.toStringAsFixed(6);
                              lngController.text = picked.longitude.toStringAsFixed(6);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: radiusController,
                      decoration: const InputDecoration(labelText: 'Service Radius (km)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    if (cityController.text.isEmpty || stateController.text.isEmpty || latController.text.isEmpty || lngController.text.isEmpty) return;
                    
                    final data = {
                      'city': cityController.text,
                      'state': stateController.text,
                      'latitude': double.tryParse(latController.text) ?? 0.0,
                      'longitude': double.tryParse(lngController.text) ?? 0.0,
                      'radius': double.tryParse(radiusController.text) ?? 5.0,
                      'isActive': isActive,
                    };

                    try {
                      if (location == null) {
                        await apiClient.createLocation(data);
                      } else {
                        await apiClient.updateLocation(location['_id'], data);
                      }
                      ref.invalidate(locationsProvider);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      print('Error saving location: $e');
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
    final locationsAsync = ref.watch(locationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ref.read(adminSidebarProvider.notifier).update((state) => !state);
          },
        ),
        title: const Text('Locations Management'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Responsive.isMobile(context)
                ? IconButton(
                    icon: const Icon(Icons.add_location, color: AppColors.primaryAction),
                    onPressed: () => _showLocationDialog(context, ref),
                    tooltip: 'Add Location',
                  )
                : ElevatedButton.icon(
                    onPressed: () => _showLocationDialog(context, ref),
                    icon: const Icon(Icons.add_location),
                    label: const Text('Add Location'),
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
                  children: [
                    Text(
                      'Supported Cities & Zones',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              locationsAsync.when(
                data: (locations) {
                  if (locations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('No locations found.')),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(AppColors.background),
                      columns: const [
                        DataColumn(label: Text('City/Zone', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: locations.map<DataRow>((loc) {
                        return _buildLocationRow(context, ref, loc);
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

  DataRow _buildLocationRow(BuildContext context, WidgetRef ref, Map<String, dynamic> location) {
    bool isActive = location['isActive'] ?? true;
    
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primaryAction, size: 20),
              const SizedBox(width: 8),
              Text(location['city'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        DataCell(Text(location['state'] ?? '')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: isActive ? Colors.green : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: isActive,
                onChanged: (val) async {
                  await apiClient.updateLocation(location['_id'], {'isActive': val});
                  ref.invalidate(locationsProvider);
                },
                activeThumbColor: AppColors.primaryAction,
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                tooltip: 'Edit',
                onPressed: () => _showLocationDialog(context, ref, location),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
                onPressed: () async {
                  await apiClient.deleteLocation(location['_id']);
                  ref.invalidate(locationsProvider);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
