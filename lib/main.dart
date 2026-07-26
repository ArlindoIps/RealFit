import 'package:flutter/material.dart';

// Importa os ecrãs que cada um vai desenvolver
import 'Login/Registo/login_screen.dart';
import 'treinos/treinos_screen.dart';

void main() {
  runApp(const RealFitApp());
}

class RealFitApp extends StatelessWidget {
  const RealFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealFit',
      theme: ThemeData(
        primarySwatch: Colors.cyan, // A cor primária do vosso design
      ),
      // Para já, arranca logo no ecrã principal com as abas.
      // Mais tarde, o Colega 1 muda isto para arrancar no LoginScreen!
      home: const MainNavegacao(),
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
    const Center(child: Text("Perfil/Estatísticas Aqui")), // Aba 2
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amigos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
