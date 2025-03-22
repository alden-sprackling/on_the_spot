// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:on_the_spot/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

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

  /// Checks for an access token; if missing, attempts to refresh tokens.
  /// Then, loads the player data (username, profile picture, IQ points) and navigates accordingly.
  Future<void> _checkAuthentication() async {
    final accessToken = await _authService.getToken();
    if (accessToken != null) {
      if (mounted) {
        await Provider.of<PlayerProvider>(context, listen: false).loadPlayerData();
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      return;
    }

    final refreshToken = await _authService.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _authService.refreshToken(refreshToken);
        if (mounted) {
          await Provider.of<PlayerProvider>(context, listen: false).loadPlayerData();
        }
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
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
