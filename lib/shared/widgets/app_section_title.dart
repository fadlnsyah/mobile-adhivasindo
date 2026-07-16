import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    required this.title,
    this.actionText,
    this.onActionPressed,
    super.key,
  });

  final String? actionText;
  final VoidCallback? onActionPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black.withValues(alpha: 0.82),
            ),
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
