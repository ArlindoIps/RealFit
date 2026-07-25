import 'package:flutter/material.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  // Variáveis para guardar as escolhas do utilizador
  String energiaSelecionada = '';
  String tempoSelecionado = '';
  String humorSelecionado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView( // Permite fazer scroll se o ecrã for pequeno
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Cabeçalho
              const Text(
                'Bom dia, Arlindo!', // Mais tarde substituímos pelo nome real da base de dados
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vamos tornar hoje um dia incrível.\nAjusta o teu treino ao teu estado atual e mantém o foco nos teus objetivos.',
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Pergunta 1: Energia
              _buildPerguntaTitulo('Qual o teu nível de energia?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao(
                    texto: 'Baixa 🔋',
                    grupo: 'energia',
                    valor: 'baixa',
                    selecionado: energiaSelecionada == 'baixa',
                  ),
                  _buildOpcao(
                    texto: 'Moderada ⚡',
                    grupo: 'energia',
                    valor: 'moderada',
                    selecionado: energiaSelecionada == 'moderada',
                  ),
                  _buildOpcao(
                    texto: 'Alta 🔥',
                    grupo: 'energia',
                    valor: 'alta',
                    selecionado: energiaSelecionada == 'alta',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Pergunta 2: Tempo
              _buildPerguntaTitulo('Quanto tempo tens disponível?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao(
                    texto: '10 - 20 min',
                    grupo: 'tempo',
                    valor: 'curto',
                    selecionado: tempoSelecionado == 'curto',
                  ),
                  _buildOpcao(
                    texto: '20 - 40 min',
                    grupo: 'tempo',
                    valor: 'medio',
                    selecionado: tempoSelecionado == 'medio',
                  ),
                  _buildOpcao(
                    texto: '40+ min',
                    grupo: 'tempo',
                    valor: 'longo',
                    selecionado: tempoSelecionado == 'longo',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Pergunta 3: Humor
              _buildPerguntaTitulo('Como te sentes?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao(
                    texto: 'Motivado 💪',
                    grupo: 'humor',
                    valor: 'motivado',
                    selecionado: humorSelecionado == 'motivado',
                  ),
                  _buildOpcao(
                    texto: 'Tranquilo 🧘',
                    grupo: 'humor',
                    valor: 'tranquilo',
                    selecionado: humorSelecionado == 'tranquilo',
                  ),
                  _buildOpcao(
                    texto: 'Stressado 🤯',
                    grupo: 'humor',
                    valor: 'stressado',
                    selecionado: humorSelecionado == 'stressado',
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Botão de Ação
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Aqui vamos colocar a lógica para gerar o treino e gravar no Firebase!
                    print('Energia: $energiaSelecionada, Tempo: $tempoSelecionado, Humor: $humorSelecionado');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DD0E1), // Ciano
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Descobrir Treino de hoje >',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para os Títulos das Perguntas
  Widget _buildPerguntaTitulo(String titulo) {
    return Center(
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // Widget auxiliar para construir os "Chips" de resposta
  Widget _buildOpcao({
    required String texto,
    required String grupo,
    required String valor,
    required bool selecionado,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (grupo == 'energia') energiaSelecionada = valor;
            if (grupo == 'tempo') tempoSelecionado = valor;
            if (grupo == 'humor') humorSelecionado = valor;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: selecionado ? const Color(0xFFE0F7FA) : Colors.white, // Muda a cor se selecionado
            border: Border.all(
              color: selecionado ? const Color(0xFF4DD0E1) : Colors.transparent, // Borda ciano
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              if (!selecionado)
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}