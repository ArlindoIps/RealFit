import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Authentication/auth_gate.dart';

// Importa os ecrãs que cada um vai desenvolver
import 'treinos/treinos_screen.dart';
import 'social/amigos_screen.dart';
import 'Authentication/perfil_screen.dart';

void main() async {
  // Necessário para poder chamar código assíncrono (Firebase.initializeApp)
  // antes de runApp().
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RealFitApp());
}

class RealFitApp extends StatelessWidget {
  const RealFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan, // A cor primária do vosso design
      ),
      // O AuthGate decide, com base no estado de autenticação do Firebase,
      // se mostra o LoginScreen, o Questionário ou a navegação principal.
      home: AuthGate(),
    );
  }
}

class MainNavegacao extends StatefulWidget {
  const MainNavegacao({super.key});
  @override
  State<MainNavegacao> createState() => _MainNavegacaoState();
}

class _MainNavegacaoState extends State<MainNavegacao> {
  int _indiceAtual = 0;
  // Lista dos ecrãs de cada colega
  final List<Widget> _ecras = [
    const TreinosScreen(), // Aba 0
    const AmigosScreen(),  // Aba 1
    const ProfileScreen() 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ecras[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
