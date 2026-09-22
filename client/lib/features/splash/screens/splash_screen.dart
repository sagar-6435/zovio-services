import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    
    // Navigate to welcome screen after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted && !_navigated) {
        _navigated = true;
        context.go(AppRoutes.welcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/zovio-logo.png',
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
