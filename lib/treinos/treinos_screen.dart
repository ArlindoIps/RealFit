import 'package:flutter/material.dart';
import 'treino_ativo_screen.dart';
import 'treino_personalizado_screen.dart';
import 'treinos_anteriores_screen.dart';
import 'estatisticas_screen.dart';


/// Ecrã principal da secção de Treinos.
///
/// Este ecrã exibe o treino gerado para o dia atual e fornece navegação
/// para outras áreas da aplicação relacionadas com a atividade física,
/// como estatísticas, criação de treinos personalizados e histórico.
class TreinosScreen extends StatelessWidget {
  
  /// Lista de exercícios gerados (normalmente através de uma API externa) 
  /// com base nas respostas do utilizador no ecrã do Diário.
  /// 
  /// Pode ser `null` se o utilizador ainda não tiver gerado nenhum plano para hoje.
  final List<Map<String, dynamic>>? exerciciosGerados;

  /// Construtor padrão do [TreinosScreen].
  /// 
  /// Recebe opcionalmente os [exerciciosGerados] para popular o cartão de treino.
  const TreinosScreen({super.key, this.exerciciosGerados});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fundo cinzento claro
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildTreinoDeHojeCard(context),
            const SizedBox(height: 32),
            
            
            _buildMenuButton(
              context, 
              Icons.bar_chart, 
              'Ver estatísticas de treino', 
              const EstatisticasScreen()
            ),
            const SizedBox(height: 16),
            
            _buildMenuButton(
              context, 
              Icons.fitness_center, 
              'Criar treino Personalizado', 
              const TreinoPersonalizadoScreen() 
            ),
            const SizedBox(height: 16),
            
            _buildMenuButton(
              context, 
              Icons.history, 
              'Treinos anteriores', 
              const TreinosAnterioresScreen()
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o cartão principal em destaque que mostra o "Treino de hoje".
  ///
  /// Valida se a lista de exercicios gerados contém dados. Se estiver vazia,
  /// exibe uma mensagem a incentivar o preenchimento do Diário. Caso contrário,
  /// desenha a lista de exercícios e ativa o botão para iniciar a atividade.
  ///
  /// O parâmetro context é utilizado para permitir a navegação para o ecrã ativo.
  Widget _buildTreinoDeHojeCard(BuildContext context) {
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
                
                children: exerciciosGerados!.map((ex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${ex['nome']} - 3 x 10', 
                      style: const TextStyle(height: 1.5),
                    ),
                  );
                }).toList(),
              ),
            ),
            
          const SizedBox(height: 24),
          
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              
              onPressed: (exerciciosGerados == null || exerciciosGerados!.isEmpty) 
                  ? null 
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TreinoAtivoScreen(
                            exercicios: exerciciosGerados!,
                          ),
                        ),
                      );
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

  
  /// Constrói um componente de botão em forma de lista (ListTile) para os menus inferiores.
  ///
  /// Encapsula um Inkwell dentro de um Material para garantir que os efeitos 
  /// visuais de clique (splash) funcionam corretamente sobre fundos brancos.
  ///
  /// * [context]: O contexto de compilação necessário para o [Navigator].
  /// * [icon]: O [IconData] a ser apresentado à esquerda do texto.
  /// * [title]: A [String] que serve como título do botão.
  /// * [destino]: O [Widget] correspondente ao ecrã alvo da navegação.
  Widget _buildMenuButton(BuildContext context, IconData icon, String title, Widget destino) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destino),
          );
        },
        child: ListTile(
          leading: Icon(icon, color: Colors.black54),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        ),
      ),
    );
  }
}