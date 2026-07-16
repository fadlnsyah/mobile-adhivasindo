import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final IconData? icon;
  final bool loading;
  final VoidCallback? onPressed;
  final String text;
  final AppButtonVariant variant;

  bool get _isPrimary => variant == AppButtonVariant.primary;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isPrimary ? AppTheme.primaryColor : Colors.white;
    final foregroundColor = _isPrimary ? Colors.white : AppTheme.primaryColor;

    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.65),
          foregroundColor: foregroundColor,
          elevation: _isPrimary ? 8 : 0,
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: _isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
          ),
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: foregroundColor,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
