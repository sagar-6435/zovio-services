import 'package:flutter/material.dart';
import 'worker_profile_screen.dart';
import '../../bookings/screens/bookings_screen.dart';
import '../../../services/api_client.dart';

class WorkersScreen extends StatelessWidget {
  final String? filter;

  const WorkersScreen({super.key, this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workers')),
      body: Column(
        children: [
          if (filter != null && filter!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Showing results for: $filter',
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: apiClient.getWorkers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading workers.'));
                }

                var workers = snapshot.data ?? [];



                if (filter != null && filter!.isNotEmpty) {
                  workers = workers.where((w) {
                    final role = (w['role'] as String?) ?? '';
                    final name = (w['name'] as String?) ?? '';
                    return role.toLowerCase().contains(filter!.toLowerCase()) ||
                           name.toLowerCase().contains(filter!.toLowerCase());
                  }).toList();
                }

                if (workers.isEmpty) {
                  return const Center(child: Text('No workers found.'));
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth >= 1024) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth >= 600) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkerProfileScreen(worker: worker),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage((worker['imageUrl'] as String?) ?? 'https://i.pravatar.cc/150?img=11'),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    (worker['name'] as String?) ?? 'Unknown Worker',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (worker['role'] as String?) ?? 'Worker',
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        (worker['rating'] ?? 0.0).toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookingsScreen(worker: worker),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 36),
                                    ),
                                    child: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
