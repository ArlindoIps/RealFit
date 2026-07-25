import 'package:flutter/material.dart';

class TreinosScreen extends StatelessWidget {
  // A variável que vai receber a lista da API
  final List<Map<String, dynamic>>? exerciciosGerados;

  // Atualizamos o construtor para aceitar a variável
  const TreinosScreen({super.key, this.exerciciosGerados});

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
          
          // A LÓGICA DINÂMICA: Verifica se há exercícios vindos da API
          if (exerciciosGerados == null || exerciciosGerados!.isEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text(
                'Ainda não definiste o teu treino.\nVai à aba Diário e responde às perguntas para gerarmos o plano perfeito para ti hoje!', 
                style: TextStyle(height: 1.5, color: Colors.black54),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Faz um ciclo (map) pela lista e desenha os textos
                children: exerciciosGerados!.map((ex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${ex['nome']} - 3 x 10', // Puxa o nome da API e mete as séries hardcoded
                      style: const TextStyle(height: 1.5),
                    ),
                  );
                }).toList(),
              ),
            ),
            
          const SizedBox(height: 24),
          
          // Botão Iniciar Treino
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Só ativa o botão se houver exercícios!
              onPressed: (exerciciosGerados == null || exerciciosGerados!.isEmpty) 
                  ? null 
                  : () {
                      // Mais logo colocamos aqui a navegação para o ecrã de "Treino a Correr"
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
              onPressed: () {},
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
        onTap: () {},
      ),
    );
  }
}