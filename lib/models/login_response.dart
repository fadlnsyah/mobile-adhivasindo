import 'package:equatable/equatable.dart';

import 'user_model.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return LoginResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      token: data['token'] as String? ?? '',
      tokenType: data['token_type'] as String? ?? '',
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  final bool success;
  final String message;
  final String token;
  final String tokenType;
  final UserModel user;

  @override
  List<Object?> get props => [success, message, token, tokenType, user];
}
