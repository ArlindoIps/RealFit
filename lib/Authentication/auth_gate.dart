import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import 'login.dart';
import 'physical_screen.dart';
import '../main.dart' show MainNavegacao;

/// Key global que permite a qualquer ecrã (ex: goal_screen.dart) pedir ao
/// AuthGate para reavaliar se o questionário já foi completado, sem
/// depender de um novo evento em authStateChanges().
final GlobalKey<_AuthGateState> authGateKey = GlobalKey<_AuthGateState>();

/// Ecrã "porteiro": ouve o estado de autenticação do Firebase em tempo real
/// e decide o que mostrar. É a ÚNICA fonte de verdade para esta decisão —
/// os ecrãs de login/registo NÃO devem navegar manualmente depois de
/// autenticar, para evitar corridas com este StreamBuilder.
///
/// - Sem sessão                          -> LoginScreen
/// - Com sessão, questionário incompleto -> PhysicalCapacityScreen
/// - Com sessão, questionário completo   -> MainNavegacao (app principal)
class AuthGate extends StatefulWidget {
  AuthGate() : super(key: authGateKey);

  /// Chama isto (ex: depois de gravar o objetivo em goal_screen.dart) para
  /// forçar o AuthGate a verificar novamente se o questionário está completo.
  static void refresh() {
    authGateKey.currentState?._refreshQuestionnaireStatus();
  }

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Chave que, ao mudar, força o FutureBuilder a recriar o Future e
  // reavaliar hasCompletedQuestionnaire.
  int _refreshToken = 0;

  void _refreshQuestionnaireStatus() {
    setState(() => _refreshToken++);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder<bool>(
          key: ValueKey('${user.uid}-$_refreshToken'),
          future: DatabaseService().hasCompletedQuestionnaire(user.uid),
          builder: (context, questionnaireSnapshot) {
            if (questionnaireSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final hasCompleted = questionnaireSnapshot.data ?? false;

            if (!hasCompleted) {
              return const PhysicalCapacityScreen();
            }

            return const MainNavegacao();
          },
        );
      },
    );
  }
}
