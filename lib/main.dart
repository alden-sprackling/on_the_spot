// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/player_provider.dart';
import 'providers/message_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/phone_number_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/name_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_game_screen.dart';
import 'screens/create_game_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const OnTheSpotApp(),
    ),
  );
}

class OnTheSpotApp extends StatelessWidget {
  const OnTheSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      // Set the Splash Screen as the initial route
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const PhoneNumberScreen(),
        '/otp_verification': (context) => const OTPVerificationScreen(),
        '/name': (context) => const NameScreen(),
        '/home': (context) => const HomeScreen(),
        '/join_game': (context) => JoinGameScreen(), // Will remove const after adding functionality
        '/create_game': (context) => const CreateGameScreen(),
      },
    );
  }
}
