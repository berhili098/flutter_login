import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/registration_form_field.dart';
import './widgets/social_registration_buttons.dart';
import './widgets/terms_privacy_checkbox.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isTermsAccepted = false;
  bool _isLoading = false;

  // Validation states
  bool _isFullNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  // Error messages
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    _fullNameController.addListener(() {
      _validateFullName(_fullNameController.text);
    });

    _emailController.addListener(() {
      _validateEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      _validatePassword(_passwordController.text);
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword(_confirmPasswordController.text);
      }
    });

    _confirmPasswordController.addListener(() {
      _validateConfirmPassword(_confirmPasswordController.text);
    });
  }

  void _validateFullName(String value) {
    setState(() {
      if (value.isEmpty) {
        _isFullNameValid = false;
        _fullNameError = null;
      } else if (value.trim().length < 2) {
        _isFullNameValid = false;
        _fullNameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _isFullNameValid = false;
        _fullNameError = 'Name can only contain letters and spaces';
      } else {
        _isFullNameValid = true;
        _fullNameError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _isEmailValid = false;
        _emailError = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _isEmailValid = false;
        _emailError = 'Please enter a valid email address';
      } else {
        _isEmailValid = true;
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _isPasswordValid = false;
        _passwordError = null;
      } else if (value.length < 8) {
        _isPasswordValid = false;
        _passwordError = 'Password must be at least 8 characters';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
        _isPasswordValid = false;
        _passwordError =
            'Password must contain uppercase, lowercase, and number';
      } else {
        _isPasswordValid = true;
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _isConfirmPasswordValid = false;
        _confirmPasswordError = null;
      } else if (value != _passwordController.text) {
        _isConfirmPasswordValid = false;
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _isConfirmPasswordValid = true;
        _confirmPasswordError = null;
      }
    });
  }

  bool get _isFormValid {
    return _isFullNameValid &&
        _isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _isTermsAccepted;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Check for duplicate email (mock validation)
      if (_emailController.text.toLowerCase() == 'test@example.com') {
        throw Exception('Email already exists');
      }

      // Show success modal
      _showSuccessModal();
    } catch (e) {
      String errorMessage = 'Registration failed. Please try again.';

      if (e.toString().contains('Email already exists')) {
        errorMessage =
            'This email is already registered. Please use a different email.';
      } else if (e.toString().contains('network')) {
        errorMessage =
            'Network error. Please check your connection and try again.';
      }

      _showErrorSnackBar(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'Account Created!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your account has been created successfully. Please verify your email to continue.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/email-verification-screen');
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleSocialRegistration(String provider) {
    // Mock social registration
    _showErrorSnackBar('$provider registration will be available soon');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Social Registration Buttons
                SocialRegistrationButtons(
                  onGooglePressed: () => _handleSocialRegistration('Google'),
                  onApplePressed: () => _handleSocialRegistration('Apple'),
                ),

                SizedBox(height: 4.h),

                // Full Name Field
                RegistrationFormField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  showValidationIcon: true,
                  isValid: _isFullNameValid,
                  validator: (value) => _fullNameError,
                ),

                SizedBox(height: 3.h),

                // Email Field
                RegistrationFormField(
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  showValidationIcon: true,
                  isValid: _isEmailValid,
                  validator: (value) => _emailError,
                ),

                SizedBox(height: 3.h),

                // Password Field
                RegistrationFormField(
                  label: 'Password',
                  hint: 'Create a strong password',
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) => _passwordError,
                ),

                // Password Strength Indicator
                PasswordStrengthIndicator(
                  password: _passwordController.text,
                ),

                SizedBox(height: 3.h),

                // Confirm Password Field
                RegistrationFormField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onVisibilityToggle: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  showValidationIcon: true,
                  isValid: _isConfirmPasswordValid,
                  validator: (value) => _confirmPasswordError,
                ),

                SizedBox(height: 3.h),

                // Terms and Privacy Checkbox
                TermsPrivacyCheckbox(
                  isChecked: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                  onTermsPressed: () {
                    _showErrorSnackBar('Terms of Service will open in browser');
                  },
                  onPrivacyPressed: () {
                    _showErrorSnackBar('Privacy Policy will open in browser');
                  },
                ),

                SizedBox(height: 4.h),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid && !_isLoading
                        ? _handleRegistration
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      foregroundColor: _isFormValid
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Create Account',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Sign In Link
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/login-screen'),
                    child: RichText(
                      text: TextSpan(
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
