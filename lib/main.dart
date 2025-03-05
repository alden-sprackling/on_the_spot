import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/name_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_screen.dart';
import 'screens/host_lobby_screen.dart';
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
        '/': (context) => WelcomeScreen(),
        '/auth': (context) => AuthScreen(),
        '/name': (context) => NameScreen(),
        '/home': (context) => HomeScreen(),
        '/join': (context) => JoinScreen(),
        '/host_lobby': (context) => HostLobbyScreen(),
      },
    );
  }
}