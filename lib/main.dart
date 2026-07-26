import 'package:flutter/material.dart';

// Importa os ecrãs que cada um vai desenvolver
import 'Login/Registo/login_screen.dart';
import 'treinos/treinos_screen.dart';
import 'social/amigos_screen.dart';
import 'diario/diario_screen.dart';



void main() {
  runApp(const RealFitApp());
}

class RealFitApp extends StatelessWidget {
  const RealFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RealFit',
      theme: ThemeData(
        fontFamily: 'Poppins', 
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
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
  int _indiceAtual = 0; // Arranca no Diário!
  List<Map<String, dynamic>>? _exerciciosGlobais; // Guarda os exercícios aqui

  // Função que muda para a aba de Treinos com os novos exercícios
  void _mudarParaTreinos(List<Map<String, dynamic>> novosExercicios) {
    setState(() {
      _exerciciosGlobais = novosExercicios;
      _indiceAtual = 1; // 1 é a aba dos Treinos
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> ecras = [
      DiarioScreen(onTreinoGerado: _mudarParaTreinos), // Aba 0
      TreinosScreen(exerciciosGerados: _exerciciosGlobais), // Aba 1
      const AmigosScreen(),  // Aba 2
      const Center(child: Text("Aba Perfil", style: TextStyle(fontWeight: FontWeight.bold))), // Aba 3
    ];

    return Scaffold(
      body: ecras[_indiceAtual],
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.wb_sunny, 'Diário'),
              _buildNavItem(1, Icons.fitness_center, 'Treinos'),
              _buildNavItem(2, Icons.people, 'Amigos'),
              _buildNavItem(3, Icons.person, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _indiceAtual == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _indiceAtual = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Icon(icon, color: Colors.black, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3, width: 24,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4DD0E1) : Colors.transparent, 
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}