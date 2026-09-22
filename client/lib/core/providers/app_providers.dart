import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

/// Global API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// User authentication state provider (to be implemented)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Placeholder auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unauthenticated());
}

/// Auth state union
sealed class AuthState {
  const AuthState();

  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.authenticated(String userId) = AuthStateAuthenticated;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.error(String message) = AuthStateError;
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateAuthenticated extends AuthState {
  final String userId;
  const AuthStateAuthenticated(this.userId);
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}
