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
                    double aspectRatio = 0.65;
                    
                    if (constraints.maxWidth >= 1024) {
                      crossAxisCount = 4;
                      aspectRatio = 0.7;
                    } else if (constraints.maxWidth >= 600) {
                      crossAxisCount = 3;
                      aspectRatio = 0.7;
                    } else if (constraints.maxWidth < 400) {
                      aspectRatio = 0.58;
                    } else {
                      aspectRatio = 0.61; 
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: workers.length,
                      itemBuilder: (context, index) {
                        final worker = workers[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Photo
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundColor: Colors.grey.shade100,
                                      backgroundImage: NetworkImage((worker['imageUrl'] as String?) ?? 'https://i.pravatar.cc/150?img=11'),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Name
                                  Text(
                                    (worker['name'] as String?) ?? 'Unknown Worker',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  // Rating
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          (worker['rating'] ?? 0.0).toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Book Now Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookingsScreen(worker: worker),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ),
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
