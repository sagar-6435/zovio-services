class AppConstants {
  // App Info
  static const String appName = 'Zovio';
  static const String appTagline = 'Connect. Get It Done.';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = 'https://zovio-b.vercel.app/api';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // UI
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Feature Flags (for future use)
  static const bool enableFirebaseAuth = false;
  static const bool enableGoogleMaps = false;
  static const bool enableRazorpay = false;
}
