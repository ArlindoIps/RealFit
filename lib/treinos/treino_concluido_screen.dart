import 'package:flutter/material.dart';

/// Ecrã apresentado quando o utilizador conclui um treino.
///
/// Apresenta uma mensagem de congratulação, um resumo das estatísticas
/// do treino realizado e permite ao utilizador partilhar os resultados
/// ou regressar ao ecrã principal da aplicação.
class TreinoConcluidoScreen extends StatelessWidget {
  const TreinoConcluidoScreen({super.key});

  /// Constrói a interface gráfica do ecrã de treino concluído.
  ///
  /// Este método cria:
  /// - A mensagem de parabéns;
  /// - O ícone de troféu;
  /// - O cartão com as estatísticas do treino;
  /// - Os botões para partilhar o treino e regressar ao diário.
  ///
  /// context contém informação sobre a posição deste widget
  /// na árvore de widgets.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        // A SOLUÇÃO: Adicionámos o SingleChildScrollView aqui!
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Parabéns!!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text(
                'O teu corpo e a tua mente agradecem o esforço de hoje.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              
              // Ícone do Troféu
              const Text('🏆', style: TextStyle(fontSize: 150)),
              const SizedBox(height: 40),
              
              // Cartão de Estatísticas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF4DD0E1)),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Column(
                  children: [
                    Text('Estatísticas do treino', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 24),
                    Text('Tempo total: 15:00 min', style: TextStyle(fontSize: 14, height: 1.5)),
                    SizedBox(height: 8),
                    Text('Exercícios concluídos: 3 / 3', style: TextStyle(fontSize: 14, height: 1.5)),
                    SizedBox(height: 16),
                    Text('Com este treino ficas com uma streak de 4 dias', style: TextStyle(fontSize: 14, height: 1.5), textAlign: TextAlign.center),
                  ],
                ),
              ),
              
              // Tirámos o Spacer() e colocámos um SizedBox estático
              const SizedBox(height: 48),
              
              // Botões Finais
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0F7FA), 
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0,
                  ),
                  child: const Text('Partilhar com amigos', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Volta ao ecrã inicial (destrói as páginas em cima)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2EBF2),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0,
                  ),
                  child: const Text('Voltar ao diário', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}