import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/player_provider.dart';
import 'screens/phone_number_screen.dart';
import 'screens/name_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_game_screen.dart';
import 'screens/create_game_screen.dart';
import 'providers/message_provider.dart';
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
      child: OnTheSpotApp(),
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
      initialRoute: '/',
      routes: {
        '/': (context) => PhoneNumberScreen(),
        '/otp_verification': (context) => OTPVerificationScreen(),
        '/name': (context) => NameScreen(),
        '/home': (context) => HomeScreen(),
        '/join_game': (context) => JoinGameScreen(),
        '/create_game': (context) => CreateGameScreen(),
      },
    );
  }
}