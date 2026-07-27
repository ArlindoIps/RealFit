import 'package:flutter/material.dart';
import 'screens/friends_screen.dart';

// Ponto de entrada EXCLUSIVO da parte social — para testar sem o resto do projeto
// Para correr: flutter run -t lib/social/social_main.dart
void main() {
  runApp(const SocialTestApp());
}

class SocialTestApp extends StatelessWidget {
  const SocialTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealFit Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B4C8)),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      // Começa directamente no ecrã de amigos
      home: const FriendsScreen(),
    );
  }
}
