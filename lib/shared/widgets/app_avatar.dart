import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({this.imageUrl, this.radius = 24, super.key});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: hasImage
          ? null
          : Icon(
              Icons.person_rounded,
              color: AppTheme.primaryColor,
              size: radius,
            ),
    );
  }
}
