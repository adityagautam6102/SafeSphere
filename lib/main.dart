import 'package:flutter/material.dart';

import 'theme.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeSphere',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,

      // Keep the application at a phone-like width
      // when running in Chrome/Edge on desktop.
      builder: (context, child) {
        return Container(
          color: const Color(0xFF05070D),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },

      home: WelcomeScreen(),

      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}