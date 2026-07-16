import 'package:flutter/material.dart';

class EditContentPage extends StatelessWidget {
  const EditContentPage({required this.contentId, super.key});

  final String contentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Content')),
      body: Center(child: Text('Edit Content Page: $contentId')),
    );
  }
}
