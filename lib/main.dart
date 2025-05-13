// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_the_spot/providers/lobby_provider.dart';
import 'package:on_the_spot/providers/message_provider.dart';
import 'package:on_the_spot/providers/picture_provider.dart';
import 'package:on_the_spot/providers/tier_provider.dart';
import 'package:on_the_spot/screens/lobby_screen.dart';
import 'package:on_the_spot/screens/set_profile_picture_screen.dart';
import 'package:on_the_spot/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'screens/enter_phone_number_screen.dart';
import 'screens/set_name_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_game_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LobbyProvider(UserProvider())),
        ChangeNotifierProvider(create: (_) => TierProvider()),
        ChangeNotifierProvider(create: (_) => PictureProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider(
              Provider.of<UserProvider>(context, listen: false),
              Provider.of<MessageProvider>(context, listen: false),
            )),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/enter_phone_number': (context) => const EnterPhoneNumberScreen(),
        '/set_name': (context) => const SetNameScreen(),
        '/set_profile_picture': (context) => const SetProfilePictureScreen(),
        '/home': (context) => const HomeScreen(),
        '/join_game': (context) => JoinGameScreen(),
        '/lobby': (context) => const LobbyScreen(),
      },
    );
  }
}
