import 'package:equatable/equatable.dart';

import 'user_model.dart';

class ContentModel extends Equatable {
  const ContentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.image,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      image: json['image'] as String?,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>? ?? {}),
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final int id;
  final String title;
  final String content;
  final String? image;
  final UserModel author;
  final String createdAt;

  @override
  List<Object?> get props => [id, title, content, image, author, createdAt];
}
