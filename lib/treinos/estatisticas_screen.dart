import 'package:flutter/material.dart';

/// Ecrã responsável por apresentar as estatísticas do utilizador.
///
/// Exibe informações relacionadas com o histórico de treinos,
/// incluindo tempo de treino, consistência, conquistas,
/// foco de treino e atividade semanal.
class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({super.key});

  /// Constrói a interface gráfica do ecrã de estatísticas.
  ///
  /// Este método apresenta:
  /// - Estatísticas de tempo de treino;
  /// - Número de treinos concluídos;
  /// - Informações de consistência;
  /// - Foco de treino do utilizador;
  /// - Dias ativos durante a semana.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 16)),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Estatísticas',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 32),
              
              // Grelha de Cartões (2 em cima, 2 em baixo)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildEstatisticaCard(
                      titulo: 'Tempo',
                      conteudos: [
                        _buildLinhaTexto('Treino mais longo: ', '40 min'),
                        _buildLinhaTexto('Tempo médio de treino: ', '25 min'),
                        _buildLinhaTexto('Tempo médio por exercicio: ', '4 min'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEstatisticaCard(
                      titulo: 'Concluídos',
                      conteudos: [
                        _buildLinhaTexto('Treinos realizados: ', '20'),
                        _buildLinhaTexto('Treinos partilhados: ', '4'),
                        _buildLinhaTexto('Conquistas desbloqueadas: ', '13'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildEstatisticaCard(
                      titulo: 'Consistencia',
                      conteudos: [
                        _buildLinhaTexto('Streak atual: ', '4'),
                        _buildLinhaTexto('Streak mais longa: ', '10'),
                        _buildLinhaTexto('Dias ativos este mês: ', '12'),
                        _buildLinhaTexto('Média de treinos por semana: ', '3'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEstatisticaCard(
                      titulo: 'Foco de treino',
                      conteudos: [
                        _buildLinhaTexto('Tipo de treino preferido:\n', 'Flexibilidade', true),
                        _buildLinhaTexto('Parque que precisa de mais foco:\n', 'Musculação', true),
                        _buildLinhaTexto('Tipo de treino menos realizado:\n', 'Cardio', true),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              
              // Dias ativos esta semana
              const Text(
                'Dias ativos esta semana: 4',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDiaSemana('Seg.', false),
                  _buildDiaSemana('Ter.', false),
                  _buildDiaSemana('Qua.', false),
                  _buildDiaSemana('Qui', true), // Ativo (Ciano)
                  _buildDiaSemana('Sex.', true), // Ativo
                  _buildDiaSemana('Sab.', true), // Ativo
                  _buildDiaSemana('Dom.', true), // Ativo
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um cartão de estatísticas.
  ///
  /// Cada cartão apresenta um título e uma lista de informações
  /// relacionadas com uma determinada categoria.
  ///
  /// titulo representa o título do cartão.
  /// conteudos corresponde aos widgets apresentados no interior
  /// do cartão.
  Widget _buildEstatisticaCard({required String titulo, required List<Widget> conteudos}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF4DD0E1), width: 1.2), // Borda Ciano
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...conteudos,
        ],
      ),
    );
  }

  /// Constrói uma linha de texto formatada.
  ///
  /// O primeiro texto é apresentado normalmente e o segundo
  /// em negrito para destacar o valor da estatística.
  ///
  /// textoNormal representa a descrição da estatística.
  /// textoNegrito representa o respetivo valor.
  /// quebrarLinha define se o texto deve ser centrado.
  Widget _buildLinhaTexto(String textoNormal, String textoNegrito, [bool quebrarLinha = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: textoNormal),
            TextSpan(
              text: textoNegrito,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: quebrarLinha ? TextAlign.center : TextAlign.left,
        style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
      ),
    );
  }

  /// Constrói o indicador visual de um dia da semana.
  ///
  /// O dia é apresentado dentro de um círculo cuja cor varia
  /// consoante exista ou não atividade nesse dia.
  ///
  /// dia corresponde à abreviatura do dia da semana.
  /// ativo indica se o utilizador realizou treino nesse dia.
  Widget _buildDiaSemana(String dia, bool ativo) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ativo ? const Color(0xFF80DEEA) : Colors.black45, // Ciano se ativo, Cinzento se não
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          dia,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}