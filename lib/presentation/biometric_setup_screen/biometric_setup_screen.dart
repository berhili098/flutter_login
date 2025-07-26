import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/benefits_list_widget.dart';
import './widgets/biometric_icon_widget.dart';
import './widgets/privacy_explanation_widget.dart';
import './widgets/success_animation_widget.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({Key? key}) : super(key: key);

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  String _biometricType = 'Biometric';
  bool _isLoading = false;
  bool _showSuccess = false;
  bool _isBiometricAvailable = false;
  bool _isEnrolled = false;

  final List<Map<String, dynamic>> _mockUsers = [
    {
      "id": 1,
      "email": "john.doe@example.com",
      "password": "SecurePass123!",
      "biometricEnabled": false,
    },
    {
      "id": 2,
      "email": "jane.smith@example.com",
      "password": "MyPassword456@",
      "biometricEnabled": false,
    },
    {
      "id": 3,
      "email": "admin@company.com",
      "password": "AdminAccess789#",
      "biometricEnabled": true,
    }
  ];

  @override
  void initState() {
    super.initState();
    _detectBiometricCapability();
  }

  Future<void> _detectBiometricCapability() async {
    try {
      if (kIsWeb) {
        // Web fallback - assume fingerprint available
        setState(() {
          _biometricType = 'Fingerprint';
          _isBiometricAvailable = true;
          _isEnrolled = true;
        });
        return;
      }

      // Platform-specific detection
      if (Platform.isIOS) {
        // iOS device capability detection
        setState(() {
          _biometricType = 'Face ID'; // Default to Face ID for iOS
          _isBiometricAvailable = true;
          _isEnrolled = true;
        });
      } else if (Platform.isAndroid) {
        // Android device capability detection
        setState(() {
          _biometricType = 'Fingerprint';
          _isBiometricAvailable = true;
          _isEnrolled = true;
        });
      }
    } catch (e) {
      // Fallback for unsupported devices
      setState(() {
        _biometricType = 'Biometric';
        _isBiometricAvailable = false;
        _isEnrolled = false;
      });
    }
  }

  Future<void> _enableBiometric() async {
    if (!_isBiometricAvailable) {
      _showUnsupportedDeviceDialog();
      return;
    }

    if (!_isEnrolled) {
      _showEnrollmentRequiredDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate biometric authentication setup
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful biometric setup
      final success = await _performBiometricSetup();

      if (success) {
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSetupFailedDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSetupFailedDialog();
    }
  }

  Future<bool> _performBiometricSetup() async {
    try {
      if (kIsWeb) {
        // Web implementation - simulate successful setup
        return true;
      }

      // Mobile implementation
      if (Platform.isIOS) {
        // iOS biometric setup
        return true;
      } else if (Platform.isAndroid) {
        // Android biometric setup
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void _setupLater() {
    // Store user preference to skip biometric setup
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _showUnsupportedDeviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Biometric Not Available',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Your device doesn\'t support biometric authentication. You can still use password-based login for secure access.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToNextScreen();
              },
              child: Text(
                'Continue with Password',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEnrollmentRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Setup Required',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Please set up $_biometricType in your device settings first, then return to enable biometric login.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Go to Settings',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setupLater();
              },
              child: Text(
                'Skip for Now',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSetupFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Setup Failed',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Unable to enable biometric authentication. Please try again or continue with password login.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _enableBiometric();
              },
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setupLater();
              },
              child: Text(
                'Skip for Now',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSuccessAnimationComplete() {
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _showSuccess
            ? SuccessAnimationWidget(
                onAnimationComplete: _onSuccessAnimationComplete,
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header with back button
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.lightTheme.colorScheme.surface,
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 5.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Biometric Setup',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 10.w), // Balance the back button
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Biometric icon with animation
                    BiometricIconWidget(biometricType: _biometricType),

                    SizedBox(height: 4.h),

                    // Main heading
                    Text(
                      'Sign in quickly and securely',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 2.h),

                    // Subtitle
                    Text(
                      'Use your ${_biometricType.toLowerCase()} to access your account faster and more securely than ever before.',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 6.h),

                    // Benefits list
                    BenefitsListWidget(biometricType: _biometricType),

                    SizedBox(height: 4.h),

                    // Privacy explanation
                    const PrivacyExplanationWidget(),

                    SizedBox(height: 6.h),

                    // Action buttons
                    ActionButtonsWidget(
                      biometricType: _biometricType,
                      onEnableBiometric: _enableBiometric,
                      onSetupLater: _setupLater,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
      ),
    );
  }
}
