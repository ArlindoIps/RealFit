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
        fontFamily: 'Poppins', // Se usarem a fonte Poppins
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Fundo cinzento claro global
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
  // Começamos no índice 1 para abrir logo o teu ecrã de Treinos!
  int _indiceAtual = 1; 

  // Lista dos ecrãs de cada colega (4 abas agora, conforme a tua imagem)
  final List<Widget> _ecras = [
    const DiarioScreen(), // Aba 0
    const TreinosScreen(), // Aba 1 - O TEU ECRÃ
    const AmigosScreen(),  // Aba 2 - O Colega 3
    const Center(child: Text("Aba Perfil", style: TextStyle(fontWeight: FontWeight.bold))), // Aba 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ecras[_indiceAtual],
      // Aqui está a magia da Barra Flutuante!
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16), // Margens para flutuar
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // Bordas bem circulares
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

  // Função que constrói cada botão da barra de navegação
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
        mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
        children: [
          Icon(
            icon,
            color: Colors.black, // Ícones sempre pretos e sólidos
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Texto SEMPRE em negrito (bold)
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          // A Barrinha indicadora (Ciano se selecionada, invisível se não)
          Container(
            height: 3,
            width: 24,
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