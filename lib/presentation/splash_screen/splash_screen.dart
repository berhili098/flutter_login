import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _showRetryButton = false;
  bool _isInitialized = false;
  String _statusMessage = 'Initializing...';

  // Mock authentication data
  final Map<String, dynamic> _mockUserData = {
    "authenticated_users": [
      {
        "email": "john.doe@example.com",
        "password": "SecurePass123!",
        "name": "John Doe",
        "isVerified": true,
        "hasCompletedOnboarding": true,
        "biometricEnabled": true,
        "lastLoginDate": "2025-01-25T10:30:00Z",
        "sessionToken": "valid_token_12345",
        "tokenExpiry": "2025-01-27T10:30:00Z"
      },
      {
        "email": "jane.smith@example.com",
        "password": "MyPassword456@",
        "name": "Jane Smith",
        "isVerified": true,
        "hasCompletedOnboarding": false,
        "biometricEnabled": false,
        "lastLoginDate": "2025-01-20T15:45:00Z",
        "sessionToken": "expired_token_67890",
        "tokenExpiry": "2025-01-22T15:45:00Z"
      }
    ],
    "app_config": {
      "version": "1.0.0",
      "forceUpdate": false,
      "maintenanceMode": false,
      "biometricSupported": true
    }
  };

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _startInitialization();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _startInitialization() async {
    setState(() {
      _isLoading = true;
      _showRetryButton = false;
      _statusMessage = 'Initializing...';
    });

    try {
      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw Exception('No internet connection');
      }

      // Simulate initialization steps with realistic delays
      await _performInitializationSteps();

      // Determine navigation path
      await _determineNavigationPath();
    } catch (e) {
      _handleInitializationError();
    }
  }

  Future<void> _performInitializationSteps() async {
    // Step 1: Load app configuration
    setState(() => _statusMessage = 'Loading configuration...');
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 2: Initialize secure storage
    setState(() => _statusMessage = 'Initializing secure storage...');
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 3: Check authentication status
    setState(() => _statusMessage = 'Checking authentication...');
    await Future.delayed(const Duration(milliseconds: 700));

    // Step 4: Load user preferences
    setState(() => _statusMessage = 'Loading preferences...');
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isInitialized = true;
      _statusMessage = 'Ready!';
    });
  }

  Future<void> _determineNavigationPath() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');
    final isFirstTime = prefs.getBool('is_first_time') ?? true;

    // Simulate token validation
    final currentUser = _mockUserData["authenticated_users"].firstWhere(
      (user) => user["sessionToken"] == storedToken,
      orElse: () => null,
    );

    if (currentUser != null) {
      final tokenExpiry = DateTime.parse(currentUser["tokenExpiry"]);
      final isTokenValid = tokenExpiry.isAfter(DateTime.now());

      if (isTokenValid) {
        // Valid session - go to main dashboard (simulated)
        _navigateToScreen('/login-screen'); // Placeholder navigation
      } else {
        // Expired session - go to login
        _navigateToScreen('/login-screen');
      }
    } else if (isFirstTime) {
      // First time user - show onboarding (simulated)
      _navigateToScreen('/registration-screen'); // Placeholder navigation
    } else {
      // Returning user without valid session
      _navigateToScreen('/login-screen');
    }
  }

  void _navigateToScreen(String route) {
    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _handleInitializationError() {
    setState(() {
      _isLoading = false;
      _showRetryButton = true;
      _statusMessage = 'Connection timeout';
    });

    // Auto-retry after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetryButton) {
        _startInitialization();
      }
    });
  }

  void _onRetryPressed() {
    _startInitialization();
  }

  void _onLogoAnimationComplete() {
    if (!_isInitialized) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundGradientWidget(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedLogoWidget(
                          onAnimationComplete: _onLogoAnimationComplete,
                        ),
                        SizedBox(height: 8.h),
                        _showRetryButton
                            ? RetryButtonWidget(
                                onRetry: _onRetryPressed,
                                isVisible: _showRetryButton,
                              )
                            : LoadingIndicatorWidget(
                                isVisible: _isLoading,
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    children: [
                      Text(
                        'Flutter Login',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Secure Authentication',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AnimatedOpacity(
                        opacity: _isLoading && !_showRetryButton ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _statusMessage,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
