import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/email_display_widget.dart';
import './widgets/resend_timer_widget.dart';
import './widgets/verification_header_widget.dart';
import './widgets/verification_instructions_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  bool _isResending = false;
  bool _isVerified = false;
  String _userEmail = 'user@example.com';
  Timer? _verificationCheckTimer;

  // Mock user data for demonstration
  final Map<String, dynamic> mockUserData = {
    'email': 'user@example.com',
    'firstName': 'John',
    'lastName': 'Doe',
    'isVerified': false,
    'verificationToken': 'mock_token_12345',
    'registrationDate': '2025-01-26',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _extractEmailFromArguments();
    _startPeriodicVerificationCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verificationCheckTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerificationStatus();
    }
  }

  void _extractEmailFromArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['email'] != null) {
        setState(() {
          _userEmail = args['email'] as String;
          mockUserData['email'] = _userEmail;
        });
      }
    });
  }

  void _startPeriodicVerificationCheck() {
    _verificationCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => _checkVerificationStatus(),
    );
  }

  Future<void> _checkVerificationStatus() async {
    try {
      // Simulate API call to check verification status
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock verification check - in real app, this would be an API call
      final isVerified = mockUserData['isVerified'] as bool;

      if (isVerified && !_isVerified) {
        setState(() {
          _isVerified = true;
        });
        _showVerificationSuccess();
      }
    } catch (e) {
      // Handle verification check error silently
    }
  }

  void _showVerificationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Email Verified!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your account has been successfully verified. You can now access all features.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login-screen',
                    (route) => false,
                  );
                },
                child: Text('Continue to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResendEmail() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      // Simulate API call to resend verification email
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful resend
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification email sent successfully!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send email. Please try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _handleOpenEmailApp() {
    try {
      // Simulate opening email app
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Opening default email app...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open email app. Please check your email manually.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onError,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleUseDifferentEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Use Different Email?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You will be redirected to the registration screen to update your email address.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                context,
                '/registration-screen',
                arguments: {
                  'prefillData': mockUserData,
                  'editMode': true,
                },
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleEditEmail() {
    Navigator.pushReplacementNamed(
      context,
      '/registration-screen',
      arguments: {
        'prefillData': mockUserData,
        'editMode': true,
        'focusEmail': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Verify Email',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/login-screen'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: 4.h),

                  // Header with mail icon and title
                  const VerificationHeaderWidget(),

                  SizedBox(height: 4.h),

                  // Email display with edit option
                  EmailDisplayWidget(
                    email: _userEmail,
                    onEditEmail: _handleEditEmail,
                  ),

                  SizedBox(height: 3.h),

                  // Verification instructions
                  const VerificationInstructionsWidget(),

                  SizedBox(height: 4.h),

                  // Resend timer and button
                  ResendTimerWidget(
                    onResendEmail: _handleResendEmail,
                    isResending: _isResending,
                  ),

                  const Spacer(),

                  SizedBox(height: 4.h),

                  // Action buttons
                  ActionButtonsWidget(
                    onOpenEmailApp: _handleOpenEmailApp,
                    onUseDifferentEmail: _handleUseDifferentEmail,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
