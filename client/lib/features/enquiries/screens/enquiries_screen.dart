import 'package:flutter/material.dart';

class EnquiriesScreen extends StatelessWidget {
  const EnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enquiries')),
      body: const Center(
        child: Text('Enquiries Screen'),
      ),
    );
  }
}
