import 'package:flutter/material.dart';

class WorkerRegistrationScreen extends StatelessWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Registration'),
      ),
      body: const Center(
        child: Text('Staff Form / Worker Registration'),
      ),
    );
  }
}
