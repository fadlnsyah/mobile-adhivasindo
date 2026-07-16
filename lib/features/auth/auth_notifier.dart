import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/auth_storage.dart';
import '../../models/login_response.dart';
import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStorageProvider = Provider<AuthStorage>((ref) {
  return AuthStorage();
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthState extends Equatable {
  const AuthState({this.loading = false});

  final bool loading;

  AuthState copyWith({bool? loading}) {
    return AuthState(loading: loading ?? this.loading);
  }

  @override
  List<Object?> get props => [loading];
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loading: true);

    try {
      final response = await ref
          .read(authServiceProvider)
          .login(email: email, password: password);

      final authStorage = ref.read(authStorageProvider);
      await authStorage.saveToken(response.token);
      await authStorage.saveUser(response.user);

      return response;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> logout() async {
    await ref.read(authStorageProvider).clear();
  }
}
