import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatefulWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  String? _loadingProvider;

  void _handleSocialLogin(String provider) async {
    if (widget.isLoading || _loadingProvider != null) return;

    setState(() {
      _loadingProvider = provider;
    });

    // Simulate social login process
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _loadingProvider = null;
    });

    widget.onSocialLogin(provider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),

        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login Button
            Expanded(
              child: _SocialLoginButton(
                provider: 'Google',
                iconName: 'g_translate',
                backgroundColor: Colors.white,
                borderColor: AppTheme.lightTheme.colorScheme.outline,
                textColor: AppTheme.lightTheme.colorScheme.onSurface,
                iconColor: Colors.red,
                isLoading: _loadingProvider == 'Google',
                onPressed: () => _handleSocialLogin('Google'),
                enabled: !widget.isLoading && _loadingProvider == null,
              ),
            ),
            SizedBox(width: 3.w),

            // Apple Login Button (iOS only, or show on all platforms)
            Expanded(
              child: _SocialLoginButton(
                provider: 'Apple',
                iconName: 'apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                iconColor: Colors.white,
                isLoading: _loadingProvider == 'Apple',
                onPressed: () => _handleSocialLogin('Apple'),
                enabled: !widget.isLoading && _loadingProvider == null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String provider;
  final String iconName;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool enabled;

  const _SocialLoginButton({
    Key? key,
    required this.provider,
    required this.iconName,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.isLoading,
    required this.onPressed,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    color: iconColor,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      provider,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
