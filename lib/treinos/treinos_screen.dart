import 'package:flutter/material.dart';

class TreinosScreen extends StatelessWidget {
  const TreinosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fundo cinzento claro
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildTreinoDeHojeCard(),
            const SizedBox(height: 32),
            _buildMenuButton(Icons.bar_chart, 'Ver estatísticas de treino'),
            const SizedBox(height: 16),
            _buildMenuButton(Icons.fitness_center, 'Criar treino Personalizado'),
            const SizedBox(height: 16),
            _buildMenuButton(Icons.history, 'Treinos anteriores'),
          ],
        ),
      ),
    );
  }

  // Cartão Principal: Treino de Hoje
  Widget _buildTreinoDeHojeCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Treino de hoje',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          // Lista de exercícios
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Flexões - 3 x 10', style: TextStyle(height: 1.8)),
                Text('Burpees - 2 x 8', style: TextStyle(height: 1.8)),
                Text('Agachamentos - 4 x 15', style: TextStyle(height: 1.8)),
                Text('Lunges - 3 x 10', style: TextStyle(height: 1.8)),
                Text('Abdominais - 4 x 20', style: TextStyle(height: 1.8)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Botão Iniciar Treino
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Ação para iniciar o treino
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB2EBF2), // Cor ciano clara
                foregroundColor: Colors.black, // Cor do texto
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Iniciar treino',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Botão Descarregar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Ação para descarregar
              },
              icon: const Icon(Icons.download, size: 20, color: Colors.black87),
              label: const Text(
                'Descarregar',
                style: TextStyle(color: Colors.black87),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botões de Menu Inferiores
  Widget _buildMenuButton(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: () {
          // Navegação para os outros ecrãs
        },
      ),
    );
  }
}