import 'package:flutter/material.dart';

class ContentDetailPage extends StatelessWidget {
  const ContentDetailPage({required this.contentId, super.key});

  final String contentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: Center(child: Text('Content Detail Page: $contentId')),
    );
  }
}
