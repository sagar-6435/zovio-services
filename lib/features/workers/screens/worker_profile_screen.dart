import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatelessWidget {
  final String workerId;

  const WorkerProfileScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
      ),
      body: Center(
        child: Text('Profile for Worker \$workerId'),
      ),
    );
  }
}
