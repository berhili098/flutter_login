import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isBiometricAvailable = true;
  String? _errorMessage;

  // Mock credentials for testing
  final Map<String, dynamic> _mockCredentials = {
    "admin": {
      "email": "admin@secureauth.com",
      "password": "admin123",
      "role": "Administrator"
    },
    "user": {
      "email": "user@secureauth.com",
      "password": "user123",
      "role": "User"
    },
    "demo": {
      "email": "demo@secureauth.com",
      "password": "demo123",
      "role": "Demo User"
    }
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate checking biometric availability
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  Future<void> _handleLogin(
      String email, String password, bool rememberMe) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      bool isValidCredential = false;
      String userRole = '';

      for (String key in _mockCredentials.keys) {
        final credentials = _mockCredentials[key] as Map<String, dynamic>;
        if (credentials['email'] == email &&
            credentials['password'] == password) {
          isValidCredential = true;
          userRole = credentials['role'];
          break;
        }
      }

      if (isValidCredential) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        // Show success toast
        Fluttertoast.showToast(
          msg: "Login successful! Welcome back.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          textColor: AppTheme.lightTheme.colorScheme.onPrimary,
        );

        // Navigate to dashboard (simulated)
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          // In a real app, this would navigate to the dashboard
          _showSuccessDialog(userRole);
        }
      } else {
        // Invalid credentials
        setState(() {
          _errorMessage =
              "Invalid email or password. Please check your credentials and try again.";
        });

        HapticFeedback.mediumImpact();
        Fluttertoast.showToast(
          msg: "Invalid credentials. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          textColor: AppTheme.lightTheme.colorScheme.onError,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Network error. Please check your connection and try again.";
      });

      HapticFeedback.heavyImpact();
      Fluttertoast.showToast(
        msg: "Connection error. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      // Success
      HapticFeedback.lightImpact();

      Fluttertoast.showToast(
        msg: "Biometric authentication successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _showSuccessDialog("Biometric User");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Biometric authentication failed. Please try again.";
      });

      HapticFeedback.heavyImpact();
      Fluttertoast.showToast(
        msg: "Biometric authentication failed.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate social login process
      await Future.delayed(const Duration(seconds: 2));

      // Success
      HapticFeedback.lightImpact();

      Fluttertoast.showToast(
        msg: "$provider login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _showSuccessDialog("$provider User");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "$provider login failed. Please try again.";
      });

      HapticFeedback.heavyImpact();
      Fluttertoast.showToast(
        msg: "$provider login failed.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(String userRole) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Login Successful',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Welcome back, $userRole!\nYou have successfully logged into SecureAuth.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, navigate to dashboard here
              },
              child: Text(
                'Continue',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),

                // App Logo
                AppLogoWidget(isSmall: true),
                SizedBox(height: 6.h),

                // Welcome Text
                Text(
                  'Welcome Back',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Sign in to your account to continue',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'error',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],

                // Login Form
                LoginFormWidget(
                  onLogin: _handleLogin,
                  isLoading: _isLoading,
                ),

                // Biometric Authentication
                BiometricAuthWidget(
                  onBiometricLogin: _handleBiometricLogin,
                  isAvailable: _isBiometricAvailable,
                ),

                // Social Login
                SocialLoginWidget(
                  onSocialLogin: _handleSocialLogin,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 6.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New user? ",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushNamed(
                                  context, '/registration-screen');
                            },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
