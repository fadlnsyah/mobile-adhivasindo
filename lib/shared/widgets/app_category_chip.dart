import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppCategoryChip extends StatelessWidget {
  const AppCategoryChip({
    required this.title,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final VoidCallback? onTap;
  final bool selected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black.withValues(alpha: 0.7),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
