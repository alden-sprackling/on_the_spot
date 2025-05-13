// lib/src/ui/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// Splash screen that checks authentication and directs to the correct screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    try {
      await auth.loadUserFromStorage();
      if (!auth.isAuthenticated) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/enter_phone_number',
          (Route<dynamic> route) => false,
        );
      } else if (auth.user!.name == null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/set_name',
          (Route<dynamic> route) => false,
        );
      } else if (auth.user!.profilePic == null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/set_profile_picture',
          (Route<dynamic> route) => false,
        );
      } else {
        user.fetchProfile();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      // On error, go to phone entry
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/enter_phone_number',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
