import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/login_response.dart';
import '../../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
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
      return await ref
          .read(authServiceProvider)
          .login(email: email, password: password);
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
