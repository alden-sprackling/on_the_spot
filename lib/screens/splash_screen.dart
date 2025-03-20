// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:on_the_spot/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService(baseUrl: 'https://onthespotgame.com');

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  /// Checks for an access token, and if not found, attempts to refresh tokens.
  Future<void> _checkAuthentication() async {
    // Try to get the stored access token.
    final accessToken = await _authService.getToken();
    if (accessToken != null) {
      // Access token exists; assume user is authenticated.
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // No access token; try to use the refresh token.
      final refreshToken = await _authService.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Attempt to refresh tokens.
          await _authService.refreshToken(refreshToken);
          // If refresh is successful, navigate to Home.
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } catch (e) {
          // Refresh failed; navigate to sign-in flow.
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        }
      } else {
        // No refresh token; navigate to sign-in flow.
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking authentication.
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
