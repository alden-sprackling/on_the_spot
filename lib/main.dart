import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/appearance_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_screen.dart';
import 'screens/host_lobby_screen.dart';
import 'providers/app_state.dart';
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
        ChangeNotifierProvider(create: (_) => AppState()),
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
        '/appearance': (context) => AppearanceScreen(),
        '/home': (context) => HomeScreen(),
        '/join': (context) => JoinScreen(),
        '/host_lobby': (context) => HostLobbyScreen(),
      },
    );
  }
}