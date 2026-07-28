import 'package:flutter/material.dart';
import 'treino_concluido_screen.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Ecrã responsável pela execução de um treino.
///
/// Apresenta os exercícios um a um, permitindo ao utilizador
/// visualizar as instruções, acompanhar as séries e avançar
/// para o exercício seguinte até concluir o treino.
class TreinoAtivoScreen extends StatefulWidget {

  /// Lista de exercícios recebida do ecrã anterior.
  final List<Map<String, dynamic>> exercicios;

  /// Construtor da classe TreinoAtivoScreen.
  ///
  /// Recebe a lista de exercícios que serão apresentados
  /// durante a sessão de treino.
  const TreinoAtivoScreen({super.key, required this.exercicios});

  /// Cria o estado associado ao ecrã de treino ativo.
  @override
  State<TreinoAtivoScreen> createState() => _TreinoAtivoScreenState();
}

/// Classe responsável pela gestão do estado do treino.
///
/// Controla o exercício atual, a navegação entre exercícios
/// e a atualização da interface gráfica.
class _TreinoAtivoScreenState extends State<TreinoAtivoScreen> {
  /// Índice do exercício atualmente apresentado.
  int _exercicioAtual = 0;

  bool _isTreinoDescarregado = false;

  /// Avança para o exercício seguinte.
  ///
  /// Caso ainda existam exercícios por realizar,
  /// incrementa o índice do exercício atual.
  ///
  /// Quando o último exercício é concluído,
  /// navega automaticamente para o ecrã de conclusão
  /// do treino.
void _proximoExercicio() async { 
    if (_exercicioAtual < widget.exercicios.length - 1) {
      setState(() {
        _exercicioAtual++;
      });
    } else {
      
      final uid = FirebaseAuth.instance.currentUser?.uid;
      
      final meuNome = "O teu amigo"; 

      if (uid != null) {
        
        await DatabaseService().notificarAmigosTreinoConcluido(
          uid, 
          meuNome, 
          "Treino de Hoje"
        );
      }

      // 3. Ir para o ecrã de Parabéns
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TreinoConcluidoScreen()),
        );
      }
    }
  }

  /// Constrói a interface gráfica do treino ativo.
  ///
  /// Este método apresenta:
  /// - Nome do exercício;
  /// - Imagem ilustrativa;
  /// - Descrição e dicas;
  /// - Zona muscular trabalhada;
  /// - Séries e repetições;
  /// - Botão para avançar para o exercício seguinte.
  @override
  Widget build(BuildContext context) {
    final exercicio = widget.exercicios[_exercicioAtual];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sair', style: TextStyle(color: Colors.black, fontSize: 16)),
        titleSpacing: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: Center(
              child: Text('00:25', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                exercicio['nome'] ?? 'Exercício',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Placeholder do Vídeo
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      exercicio['imagem'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Botão Descarregar
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _isTreinoDescarregado ? null : () async {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null) {
                      
                      await DatabaseService().salvarTreinoDescarregado(
                        uid, 
                        'Treino Ativo / Completo', 
                        '250MB' // Tamanho estimado do pacote do treino
                      );

                      
                      setState(() {
                        _isTreinoDescarregado = true;
                      });

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Treino descarregado com sucesso para modo offline!')),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    _isTreinoDescarregado ? Icons.check : Icons.download, 
                    size: 16, 
                    color: _isTreinoDescarregado ? Colors.grey : Colors.black87
                  ),
                  label: Text(
                    _isTreinoDescarregado ? 'Descarregado' : 'Descarregar', 
                    style: TextStyle(
                      color: _isTreinoDescarregado ? Colors.grey : Colors.black87, 
                      fontSize: 12
                    )
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _isTreinoDescarregado ? Colors.grey : const Color(0xFF4DD0E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Cartões de Dicas e Foco
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF4DD0E1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          const Text('Dicas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          Text(
                            exercicio['descricao'],
                            style: const TextStyle(fontSize: 12, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF4DD0E1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Column(
                        children: [
                          Text('Onde deves sentir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 16),
                          Text('Músculo Alvo', style: TextStyle(fontSize: 12, height: 1.5), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Séries e Microfone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSetRow('Set 1 - 12 Repetições'),
                      const SizedBox(height: 12),
                      _buildSetRow('Set 2 - 10 Repetições'),
                      const SizedBox(height: 12),
                      _buildSetRow('Set 3 - 8 Repetições'),
                    ],
                  ),
                  const Icon(Icons.mic, size: 32, color: Colors.black87),
                ],
              ),
              const SizedBox(height: 40),
              
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proximoExercicio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2EBF2),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0,
                  ),
                  child: Text(
                    _exercicioAtual == widget.exercicios.length - 1 ? 'Concluir Treino >' : 'Exercício seguinte >',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói uma linha correspondente a uma série do exercício.
  ///
  /// Recebe o texto da série e apresenta um indicador
  /// visual de conclusão.
  ///
  /// texto corresponde à descrição da série.
  Widget _buildSetRow(String texto) {
    return Row(
      children: [
        Text(texto, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 16),
        const Icon(Icons.radio_button_unchecked, size: 20, color: Colors.black54),
      ],
    );
  }
}