import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
  }) : super(key: key);

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppTheme.lightTheme.colorScheme.error;
      case PasswordStrength.medium:
        return AppTheme.warningLight;
      case PasswordStrength.strong:
        return AppTheme.successLight;
      case PasswordStrength.none:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.none:
        return '';
    }
  }

  double _getStrengthProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
      case PasswordStrength.none:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final strengthColor = _getStrengthColor(strength);
    final strengthText = _getStrengthText(strength);
    final progress = _getStrengthProgress(strength);

    return password.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: strengthColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              strengthText.isNotEmpty
                  ? Text(
                      'Password strength: $strengthText',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: strengthColor,
                        fontSize: 11.sp,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
  }
}

enum PasswordStrength { none, weak, medium, strong }
