import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/reset_button_widget.dart';
import './widgets/sign_in_link_widget.dart';
import './widgets/success_state_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isEmailValid = false;
  bool _showSuccessState = false;
  String? _emailError;

  // Mock registered emails for demonstration
  final List<String> _registeredEmails = [
    'user@example.com',
    'admin@company.com',
    'test@demo.com',
    'john.doe@email.com',
    'jane.smith@gmail.com',
  ];

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      _isEmailValid = email.isNotEmpty && emailRegex.hasMatch(email);
      _emailError = null;
    });
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    // Check if email is registered (mock validation)
    if (!_registeredEmails.contains(email)) {
      setState(() {
        _emailError = 'No account found with this email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock success response
      setState(() {
        _showSuccessState = true;
        _isLoading = false;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset link sent successfully',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _emailError = 'Network error. Please try again.';
      });
    }
  }

  Future<void> _resendResetLink() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate resend API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reset link sent again',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: _navigateBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),

                      // App Logo
                      const AppLogoWidget(),

                      SizedBox(height: 6.h),

                      _showSuccessState
                          ? SuccessStateWidget(
                              onResendPressed: _resendResetLink,
                            )
                          : Column(
                              children: [
                                // Explanatory Text
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    'Enter your email address and we\'ll send you a link to reset your password.',
                                    textAlign: TextAlign.center,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      height: 1.5,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                // Email Input Form
                                Form(
                                  key: _formKey,
                                  child: EmailInputWidget(
                                    controller: _emailController,
                                    errorText: _emailError,
                                    onChanged: (value) => _validateEmail(),
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                // Reset Button
                                ResetButtonWidget(
                                  isLoading: _isLoading,
                                  isEnabled: _isEmailValid,
                                  onPressed: _sendResetLink,
                                ),
                              ],
                            ),

                      SizedBox(height: 6.h),
                    ],
                  ),
                ),

                // Sign In Link
                if (!_showSuccessState)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: SignInLinkWidget(
                      onPressed: _navigateToLogin,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
