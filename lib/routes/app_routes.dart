import 'package:flutter/material.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/biometric_setup_screen/biometric_setup_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String splashScreen = '/splash-screen';
  static const String emailVerificationScreen = '/email-verification-screen';
  static const String registrationScreen = '/registration-screen';
  static const String loginScreen = '/login-screen';
  static const String biometricSetupScreen = '/biometric-setup-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => SplashScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    splashScreen: (context) => SplashScreen(),
    emailVerificationScreen: (context) => EmailVerificationScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    loginScreen: (context) => LoginScreen(),
    biometricSetupScreen: (context) => BiometricSetupScreen(),
    // TODO: Add your other routes here
  };
}
