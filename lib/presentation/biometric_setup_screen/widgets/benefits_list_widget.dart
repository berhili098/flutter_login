import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BenefitsListWidget extends StatelessWidget {
  final String biometricType;

  const BenefitsListWidget({
    Key? key,
    required this.biometricType,
  }) : super(key: key);

  List<Map<String, String>> _getBenefits() {
    return [
      {
        'icon': 'flash_on',
        'title': 'Faster Login',
        'description': 'Sign in instantly without typing passwords',
      },
      {
        'icon': 'security',
        'title': 'Enhanced Security',
        'description': 'Your biometric data stays secure on your device',
      },
      {
        'icon': 'no_encryption',
        'title': 'No Password Typing',
        'description': 'Skip the hassle of remembering complex passwords',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final benefits = _getBenefits();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits of $biometricType Authentication',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...benefits
            .map((benefit) => _buildBenefitItem(
                  iconName: benefit['icon']!,
                  title: benefit['title']!,
                  description: benefit['description']!,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildBenefitItem({
    required String iconName,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
