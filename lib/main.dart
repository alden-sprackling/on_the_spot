// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_the_spot/services/auth_service.dart';
import 'package:on_the_spot/services/user_service.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/system_message_provider.dart';
import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/enter_phone_number_screen.dart';
import 'screens/set_name_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_game_screen.dart';
import 'services/game_service.dart';
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
        ChangeNotifierProvider(create: (_) => SystemMessageProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider(gameService: GameService())),
        ChangeNotifierProvider(create: (_) => UserProvider(userService: UserService())),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService: AuthService())),
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
      initialRoute: '/', // Handle authentication and navigation
      routes: {
        '/': (context) => const SplashScreen(),
        '/enter_phone_number': (context) => const EnterPhoneNumberScreen(),
        '/set_name': (context) => const SetNameScreen(),
        '/home': (context) => const HomeScreen(),
        '/join_game': (context) => JoinGameScreen(),
      },
    );
  }
}
