class CreateContentRequest {
  const CreateContentRequest({
    required this.title,
    required this.content,
    this.image,
  });

  final String title;
  final String content;
  final String? image;

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'image': image};
  }
}
