import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DiarioScreen extends StatefulWidget {
  // AVISO: Agora recebe a função do main.dart para mudar de aba!
  final Function(List<Map<String, dynamic>>) onTreinoGerado;

  const DiarioScreen({super.key, required this.onTreinoGerado});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  String energiaSelecionada = '';
  String tempoSelecionado = '';
  String humorSelecionado = '';
  bool _estaACaregar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Bom dia, Arlindo!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vamos tornar hoje um dia incrível.\nAjusta o teu treino ao teu estado atual e mantém o foco nos teus objetivos.',
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 40),

              _buildPerguntaTitulo('Qual o teu nível de energia?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao('Baixa 🔋', 'energia', 'baixa', energiaSelecionada == 'baixa'),
                  _buildOpcao('Moderada ⚡', 'energia', 'moderada', energiaSelecionada == 'moderada'),
                  _buildOpcao('Alta 🔥', 'energia', 'alta', energiaSelecionada == 'alta'),
                ],
              ),
              const SizedBox(height: 32),

              _buildPerguntaTitulo('Quanto tempo tens disponível?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao('10 - 20 min', 'tempo', 'curto', tempoSelecionado == 'curto'),
                  _buildOpcao('20 - 40 min', 'tempo', 'medio', tempoSelecionado == 'medio'),
                  _buildOpcao('40+ min', 'tempo', 'longo', tempoSelecionado == 'longo'),
                ],
              ),
              const SizedBox(height: 32),

              _buildPerguntaTitulo('Como te sentes?'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOpcao('Motivado 💪', 'humor', 'motivado', humorSelecionado == 'motivado'),
                  _buildOpcao('Tranquilo 🧘', 'humor', 'tranquilo', humorSelecionado == 'tranquilo'),
                  _buildOpcao('Stressado 🤯', 'humor', 'stressado', humorSelecionado == 'stressado'),
                ],
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_estaACaregar || energiaSelecionada.isEmpty || tempoSelecionado.isEmpty) 
                      ? null 
                      : () async {
                          setState(() {
                            _estaACaregar = true;
                          });

                          final listaExercicios = await ApiService.obterTreino(energiaSelecionada, tempoSelecionado);

                          setState(() {
                            _estaACaregar = false;
                          });

                          // A CORREÇÃO DA NAVEGAÇÃO ESTÁ AQUI
                          // Muda de aba e mantém a barra de navegação visível!
                          widget.onTreinoGerado(listaExercicios);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DD0E1), 
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: _estaACaregar
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text(
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

  Widget _buildPerguntaTitulo(String titulo) {
    return Center(child: Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)));
  }

  Widget _buildOpcao(String texto, String grupo, String valor, bool selecionado) {
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
            color: selecionado ? const Color(0xFFE0F7FA) : Colors.white, 
            border: Border.all(color: selecionado ? const Color(0xFF4DD0E1) : Colors.transparent, width: 1.5),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [if (!selecionado) BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Center(child: Text(texto, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: selecionado ? FontWeight.bold : FontWeight.normal, color: Colors.black87))),
        ),
      ),
    );
  }
}