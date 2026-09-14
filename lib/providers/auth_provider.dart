import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole {
  customer,
  worker,
  admin,
  guest,
}

class AuthState {
  final bool isAuthenticated;
  final UserRole userRole;
  final bool isLoading;
  final bool isSetupComplete;

  const AuthState({
    required this.isAuthenticated,
    required this.userRole,
    this.isLoading = false,
    this.isSetupComplete = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserRole? userRole,
    bool? isLoading,
    bool? isSetupComplete,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      isSetupComplete: isSetupComplete ?? this.isSetupComplete,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isAuthenticated: false, userRole: UserRole.guest)) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final userRoleString = prefs.getString('userRole') ?? 'guest';
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
      isLoading: false,
      isSetupComplete: isSetupComplete,
    );
  }

  Future<void> login(UserRole role) async {
    state = state.copyWith(isLoading: true);
    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userRole', role.name);
    await prefs.setBool('isSetupComplete', false);

    state = AuthState(
      isAuthenticated: true,
      userRole: role,
      isLoading: false,
      isSetupComplete: false, // Must complete setup after login
    );
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
    await prefs.remove('isSetupComplete');

    state = const AuthState(
      isAuthenticated: false,
      userRole: UserRole.guest,
      isLoading: false,
      isSetupComplete: false,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
