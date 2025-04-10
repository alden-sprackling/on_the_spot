// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exceptions/exceptions.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _authenticate();
  }
  
  /// Handles the authentication process and navigates accordingly.
  Future<void> _authenticate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      // If this completes without throwing, authentication is successful.
      await authProvider.verifyAuthentication();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      if (e is AuthServiceException) {
        // Authentication error – navigate to enter phone number screen to authenticate.
        Navigator.pushReplacementNamed(context, '/enter_phone_number');
      } else if (e is UserServiceException) {
        // User data error – for example, if fetching user failed,
        // go to enter name screen to create a user.
        Navigator.pushReplacementNamed(context, '/set_name');
      } else {
        // Fallback for any other errors.
        Navigator.pushReplacementNamed(context, '/enter_phone_number');
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
