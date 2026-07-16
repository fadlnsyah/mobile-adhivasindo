import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  final int id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  @override
  List<Object?> get props => [id, name, email];
}
