import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_client.dart';

enum UserRole {
  customer,
  worker,
  admin,
  guest,
}

class AuthState {
  final bool isAuthenticated;
  final UserRole userRole;
  final String? userId;
  final String? name;
  final String? email;
  final String? mobile;
  final bool isLoading;
  final bool isSetupComplete;
  final bool isServiceableLocation;

  const AuthState({
    required this.isAuthenticated,
    required this.userRole,
    this.userId,
    this.name,
    this.email,
    this.mobile,
    this.isLoading = false,
    this.isSetupComplete = false,
    this.isServiceableLocation = true,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserRole? userRole,
    String? userId,
    String? name,
    String? email,
    String? mobile,
    bool? isLoading,
    bool? isSetupComplete,
    bool? isServiceableLocation,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      isLoading: isLoading ?? this.isLoading,
      isSetupComplete: isSetupComplete ?? this.isSetupComplete,
      isServiceableLocation: isServiceableLocation ?? this.isServiceableLocation,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isAuthenticated: false, userRole: UserRole.guest)) {
    _loadState();
  }

  Future<void> checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return; // Cannot check without location

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return; // Cannot check without permission
        }
      }
      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      final res = await apiClient.checkServiceability(position.latitude, position.longitude);
      final isServiceable = res['isServiceable'] ?? false;
      
      state = state.copyWith(isServiceableLocation: isServiceable);
    } catch (e) {
      print('Location check failed: $e');
    }
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final userRoleString = prefs.getString('userRole') ?? 'guest';
    final userId = prefs.getString('userId');
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');
    final mobile = prefs.getString('userMobile');
    final isSetupComplete = prefs.getBool('isSetupComplete') ?? false;

    UserRole role;
    switch (userRoleString) {
      case 'customer':
        role = UserRole.customer;
        break;
      case 'worker':
        role = UserRole.worker;
        break;
      case 'admin':
        role = UserRole.admin;
        break;
      default:
        role = UserRole.guest;
    }

    state = AuthState(
      isAuthenticated: isAuthenticated,
      userRole: role,
      userId: userId,
      name: name,
      email: email,
      mobile: mobile,
      isLoading: false,
      isSetupComplete: isSetupComplete,
      isServiceableLocation: true, // Default to true, will update async
    );

    // Check location asynchronously
    if (isAuthenticated) {
      checkLocation();
    }
  }

  Future<void> login(UserRole role, {String? mobile, String? otp}) async {
    state = state.copyWith(isLoading: true);
    
    try {
      String userId = '507f1f77bcf86cd799439011';
      bool isSetupComplete = false;
      String? name;
      String? email;
      String? actualMobile = mobile;
      
      if (mobile != null && otp != null) {
        final response = await apiClient.verifyAuth(mobile, otp);
        userId = response['user']['_id'];
        name = response['user']['name'];
        email = response['user']['email'];
        actualMobile = response['user']['mobile'] ?? mobile;
        // Skip the location setup screen by always assuming setup is complete for now
        isSetupComplete = true; // Was: !(response['isNewUser'] as bool);
        final roleString = response['user']['role'];
        if (roleString == 'worker') role = UserRole.worker;
        else if (roleString == 'admin') role = UserRole.admin;
      } else {
        // Mock network delay for non-mobile logins
        await Future.delayed(const Duration(seconds: 1));
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userRole', role.name);
      await prefs.setString('userId', userId);
      if (name != null) await prefs.setString('userName', name);
      if (email != null) await prefs.setString('userEmail', email);
      if (actualMobile != null) await prefs.setString('userMobile', actualMobile);
      await prefs.setBool('isSetupComplete', isSetupComplete);

      state = AuthState(
        isAuthenticated: true,
        userRole: role,
        userId: userId,
        name: name,
        email: email,
        mobile: actualMobile,
        isLoading: false,
        isSetupComplete: isSetupComplete,
      );

      // Check location right after login
      await checkLocation();
      
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(String name, String email, String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userMobile', mobile);
    state = state.copyWith(name: name, email: email, mobile: mobile);
  }

  Future<void> completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSetupComplete', true);
    state = state.copyWith(isSetupComplete: true);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('userRole');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userMobile');
    await prefs.remove('isSetupComplete');

    state = const AuthState(
      isAuthenticated: false,
      userRole: UserRole.guest,
      userId: null,
      name: null,
      email: null,
      mobile: null,
      isLoading: false,
      isSetupComplete: false,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
