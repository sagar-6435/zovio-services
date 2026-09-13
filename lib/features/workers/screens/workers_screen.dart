import 'package:flutter/material.dart';

class WorkersScreen extends StatelessWidget {
  final String? filter;

  const WorkersScreen({super.key, this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Workers Screen', style: TextStyle(fontSize: 24)),
            if (filter != null && filter!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Showing results for: \$filter',
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
