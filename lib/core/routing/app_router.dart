import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import 'route_names.dart';
import 'customer_shell.dart';
import 'worker_shell.dart';

// Existing screens
import '../../features/splash/screens/splash_screen.dart';
import '../../features/splash/screens/welcome_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/workers/screens/workers_screen.dart';
import '../../features/properties/screens/properties_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/enquiries/screens/enquiries_screen.dart';
import '../../features/bookings/screens/bookings_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

// A simple placeholder screen for missing routes
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Screen: $title', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.customerHome); // Fallback
                }
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Global navigator keys for shell routing
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _customerShellNavigatorKey = GlobalKey<NavigatorState>();
final _workerShellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final role = authState.userRole;
      final path = state.matchedLocation;

      // Unauthenticated users trying to access protected routes
      if (!isAuth && (path.startsWith('/customer') || path.startsWith('/worker') || path.startsWith('/admin'))) {
        return AppRoutes.welcome;
      }

      // Authenticated users trying to access auth pages
      if (isAuth && (path == AppRoutes.welcome || path == AppRoutes.splash)) {
        if (!authState.isSetupComplete) {
          if (role == UserRole.customer) return AppRoutes.customerLocation;
          if (role == UserRole.worker) return AppRoutes.workerRegister;
        } else {
          if (role == UserRole.customer) return AppRoutes.customerHome;
          if (role == UserRole.worker) return AppRoutes.workerDashboard;
          if (role == UserRole.admin) return AppRoutes.adminDashboard;
        }
      }

      // Role-based route protection and Onboarding
      if (isAuth) {
        if (!authState.isSetupComplete) {
          // Onboarding checks
          if (role == UserRole.customer && path != AppRoutes.customerLocation) {
            return AppRoutes.customerLocation;
          }
          if (role == UserRole.worker && path != AppRoutes.workerRegister && path != AppRoutes.workerVerification) {
            return AppRoutes.workerRegister; // Or allow Verification if they navigate to it
          }
        } else {
          // Post-onboarding checks
          if (role == UserRole.customer && (path.startsWith('/worker') || path.startsWith('/admin') || path == AppRoutes.customerLocation)) {
            return AppRoutes.customerHome;
          }
          if (role == UserRole.worker && (path.startsWith('/customer') || path.startsWith('/admin') || path == AppRoutes.workerRegister || path == AppRoutes.workerVerification)) {
            return AppRoutes.workerDashboard;
          }
          if (role == UserRole.admin && (path.startsWith('/customer') || path.startsWith('/worker'))) {
            return AppRoutes.adminDashboard;
          }
        }
      }

      return null;
    },
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Page not found: ${state.matchedLocation}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final role = ref.read(authProvider).userRole;
                  if (role == UserRole.customer) {
                    context.go(AppRoutes.customerHome);
                  } else if (role == UserRole.worker) {
                    context.go(AppRoutes.workerDashboard);
                  } else if (role == UserRole.admin) {
                    context.go(AppRoutes.adminDashboard);
                  } else {
                    context.go(AppRoutes.welcome);
                  }
                },
                child: const Text('Go Home'),
              )
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'];
          final otp = state.uri.queryParameters['otp'];
          return OtpVerificationScreen(phone: phone, mockOtp: otp);
        },
      ),

      // =======================================================================
      // CUSTOMER ROUTES
      // =======================================================================
      GoRoute(
        path: AppRoutes.customerLocation,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Location Setup')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).completeSetup();
              },
              child: const Text('Complete Location Setup'),
            ),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CustomerShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customerHome,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const SearchScreen(),
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) => const CategoriesScreen(),
                    routes: [
                      GoRoute(
                        path: ':categoryId',
                        builder: (context, state) {
                          final catId = state.pathParameters['categoryId'];
                          return PlaceholderScreen(title: 'Category Details: $catId');
                        },
                      ),
                    ]
                  ),
                  GoRoute(
                    path: 'service/:serviceId',
                    builder: (context, state) {
                      final serviceId = state.pathParameters['serviceId'];
                      return PlaceholderScreen(title: 'Service: $serviceId');
                    },
                  ),
                  GoRoute(
                    path: 'workers',
                    builder: (context, state) => const WorkersScreen(),
                  ),
                  GoRoute(
                    path: 'worker/:workerId',
                    builder: (context, state) {
                      final workerId = state.pathParameters['workerId'];
                      return PlaceholderScreen(title: 'Worker Profile: $workerId');
                    },
                  ),
                  GoRoute(
                    path: 'properties',
                    builder: (context, state) => const PropertiesScreen(),
                  ),
                  GoRoute(
                    path: 'property/:propertyId',
                    builder: (context, state) {
                      final propertyId = state.pathParameters['propertyId'];
                      return PlaceholderScreen(title: 'Property: $propertyId');
                    },
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => const NotificationsScreen(),
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 1: Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customerExplore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          
          // Branch 2: History (Bookings/Enquiries)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customerBookings,
                builder: (context, state) => const HistoryScreen(),
                routes: [
                  GoRoute(
                    path: ':bookingId',
                    builder: (context, state) {
                      final bookingId = state.pathParameters['bookingId'];
                      return PlaceholderScreen(title: 'Booking: $bookingId');
                    },
                  ),
                ]
              ),
              GoRoute(
                path: AppRoutes.customerEnquiries,
                builder: (context, state) => const EnquiriesScreen(),
                routes: [
                  GoRoute(
                    path: ':enquiryId',
                    builder: (context, state) {
                      final enquiryId = state.pathParameters['enquiryId'];
                      return PlaceholderScreen(title: 'Enquiry: $enquiryId');
                    },
                  ),
                ]
              ),
            ],
          ),
          
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customerProfile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const PlaceholderScreen(title: 'Edit Profile'),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'saved-workers',
                    builder: (context, state) => const PlaceholderScreen(title: 'Saved Workers'),
                  ),
                  GoRoute(
                    path: 'saved-properties',
                    builder: (context, state) => const PlaceholderScreen(title: 'Saved Properties'),
                  ),
                  GoRoute(
                    path: 'support',
                    builder: (context, state) => const PlaceholderScreen(title: 'Support'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Other customer routes that might sit on top of the shell
      GoRoute(
        path: AppRoutes.customerEnquiryCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(title: 'Create Enquiry'),
      ),
      GoRoute(
        path: AppRoutes.customerEnquiryReview,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(title: 'Review Enquiry'),
      ),
      GoRoute(
        path: AppRoutes.customerEnquirySuccess,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(title: 'Enquiry Success'),
      ),
      GoRoute(
        path: AppRoutes.customerPropertyEnquiry,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PlaceholderScreen(title: 'Property Enquiry'),
      ),

      // =======================================================================
      // WORKER ROUTES
      // =======================================================================
      GoRoute(
        path: AppRoutes.workerRegister,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Worker Register')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.workerVerification);
              },
              child: const Text('Proceed to Verification'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.workerProfileSetup,
        builder: (context, state) => const PlaceholderScreen(title: 'Worker Profile Setup'),
      ),
      GoRoute(
        path: AppRoutes.workerVerification,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Worker Verification')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).completeSetup();
              },
              child: const Text('Complete Verification'),
            ),
          ),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return WorkerShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workerDashboard,
                builder: (context, state) => const PlaceholderScreen(title: 'Worker Dashboard'),
              ),
            ],
          ),
          
          // Branch 1: Enquiries
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workerEnquiries,
                builder: (context, state) => const PlaceholderScreen(title: 'Worker Enquiries'),
                routes: [
                  GoRoute(
                    path: ':enquiryId',
                    builder: (context, state) {
                      final enquiryId = state.pathParameters['enquiryId'];
                      return PlaceholderScreen(title: 'Enquiry: $enquiryId');
                    },
                  ),
                ]
              ),
            ],
          ),
          
          // Branch 2: Jobs
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workerJobs,
                builder: (context, state) => const PlaceholderScreen(title: 'Worker Jobs'),
                routes: [
                  GoRoute(
                    path: ':jobId',
                    builder: (context, state) {
                      final jobId = state.pathParameters['jobId'];
                      return PlaceholderScreen(title: 'Job: $jobId');
                    },
                  ),
                ]
              ),
            ],
          ),
          
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workerProfile,
                builder: (context, state) => const PlaceholderScreen(title: 'Worker Profile'),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const PlaceholderScreen(title: 'Edit Worker Profile'),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const PlaceholderScreen(title: 'Worker Settings'),
                  ),
                  GoRoute(
                    path: 'earnings',
                    builder: (context, state) => const PlaceholderScreen(title: 'Worker Earnings'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // =======================================================================
      // ADMIN ROUTES
      // =======================================================================
      GoRoute(
        path: AppRoutes.adminLogin,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Login'),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Dashboard'),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Users'),
      ),
      GoRoute(
        path: AppRoutes.adminUserDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin User Details'),
      ),
      GoRoute(
        path: AppRoutes.adminWorkers,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Workers'),
      ),
      GoRoute(
        path: AppRoutes.adminWorkerDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Worker Details'),
      ),
      GoRoute(
        path: AppRoutes.adminServices,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Services'),
      ),
      GoRoute(
        path: AppRoutes.adminCategories,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Categories'),
      ),
      GoRoute(
        path: AppRoutes.adminEnquiries,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Enquiries'),
      ),
      GoRoute(
        path: AppRoutes.adminEnquiryDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Enquiry Details'),
      ),
      GoRoute(
        path: AppRoutes.adminBookings,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Bookings'),
      ),
      GoRoute(
        path: AppRoutes.adminBookingDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Booking Details'),
      ),
      GoRoute(
        path: AppRoutes.adminProperties,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Properties'),
      ),
      GoRoute(
        path: AppRoutes.adminPropertyDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Property Details'),
      ),
      GoRoute(
        path: AppRoutes.adminAdvertisements,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Advertisements'),
      ),
      GoRoute(
        path: AppRoutes.adminReviews,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Reviews'),
      ),
      GoRoute(
        path: AppRoutes.adminSupport,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Support'),
      ),
      GoRoute(
        path: AppRoutes.adminSupportDetails,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Support Details'),
      ),
      GoRoute(
        path: AppRoutes.adminReports,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Reports'),
      ),
      GoRoute(
        path: AppRoutes.adminSettings,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Settings'),
      ),
    ],
  );
});
