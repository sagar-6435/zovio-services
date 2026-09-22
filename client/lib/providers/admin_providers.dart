import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';

// --- Workers Provider ---
final workersProvider = FutureProvider<List<dynamic>>((ref) async {
  return await apiClient.getWorkers();
});

// --- Locations Provider ---
final locationsProvider = FutureProvider<List<dynamic>>((ref) async {
  return await apiClient.getLocations();
});

// --- Services Provider ---
final servicesProvider = FutureProvider<List<dynamic>>((ref) async {
  return await apiClient.getServices();
});
