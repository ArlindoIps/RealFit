import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'treino_ativo_screen.dart';

/// Ecrã de criação de um treino manual e personalizado.
///
/// Permite ao utilizador definir parâmetros granulares (músculos alvo, 
/// duração, intensidade e equipamento) e utilizar essas escolhas para 
/// forçar a API externa a gerar um plano de treino perfeitamente ajustado.
class TreinoPersonalizadoScreen extends StatefulWidget {
  const TreinoPersonalizadoScreen({super.key});

  @override
  State<TreinoPersonalizadoScreen> createState() => _TreinoPersonalizadoScreenState();
}

class _TreinoPersonalizadoScreenState extends State<TreinoPersonalizadoScreen> {
  /// Controlador do campo de texto para o nome do treino.
  final TextEditingController _nomeController = TextEditingController();
  
  /// Lista de músculos selecionados. 
  /// É uma [List] porque permite seleção múltipla (Multi-Select).
  List<String> _musculosSelecionados = []; 

  /// Variáveis de estado para as escolhas de seleção única (Single-Select).
  String _tipoSelecionado = '';
  String _tempoSelecionado = '';
  String _intensidadeSelecionada = '';
  String _localSelecionado = '';
  
  /// Flag que controla a exibição do indicador de carregamento durante a chamada à API.
  bool _estaACaregar = false;

  
  /// Adiciona ou remove um grupo muscular da lista [_musculosSelecionados].
  ///
  /// Se o [musculo] já estiver na lista, é removido (deselecionado).
  /// Caso contrário, é adicionado (selecionado).
  void _toggleMusculo(String musculo) {
    setState(() {
      if (_musculosSelecionados.contains(musculo)) {
        _musculosSelecionados.remove(musculo);
      } else {
        _musculosSelecionados.add(musculo);
      }
    });
  }

  /// Converte as seleções visuais do utilizador para os formatos exigidos pela API,
  /// faz o pedido de rede e navega para o ecrã de treino ativo.
  void _gerarEIniciarTreino() async {
    setState(() {
      _estaACaregar = true;
    });

    // Converte a nomenclatura visual da Intensidade para a chave "Energia" da API.
    String energiaApi = 'moderada';
    if (_intensidadeSelecionada == 'Baixo') energiaApi = 'baixa';
    if (_intensidadeSelecionada == 'Intenso') energiaApi = 'alta';

    // Converte as strings de Tempo para os limites reconhecidos pelo serviço.
    String tempoApi = 'medio';
    if (_tempoSelecionado == '10-20min') tempoApi = 'curto';
    if (_tempoSelecionado == '45+min') tempoApi = 'longo';

    // Chamada à API
    final listaExercicios = await ApiService.obterTreino(energiaApi, tempoApi);

    setState(() {
      _estaACaregar = false;
    });

    // Valida se o ecrã ainda está montado na árvore de widgets antes de navegar.
    // O pushReplacement é usado para não permitir ao utilizador voltar a este ecrã de setup
    // clicando no botão "Voltar" (Back) do Android/iOS durante o treino.
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TreinoAtivoScreen(
            exercicios: listaExercicios,
          ),
        ),
      );
    }
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vamos personalizar o teu treino!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 32),

              
              _buildTituloSeccao('Nome do treino?'),
              const SizedBox(height: 12),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Ex:Treino pesado de braço',
                  hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.black87, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.black87, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              
              _buildTituloSeccao('O que queres treinar?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: ['Pernas', 'Braços', 'Costas', 'Peito', 'Corpo Todo'].map((m) {
                  return _buildChip(m, _musculosSelecionados.contains(m), () => _toggleMusculo(m));
                }).toList(),
              ),
              const SizedBox(height: 24),

              
              _buildTituloSeccao('Qual o tipo de treino?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: ['Flexibilidade', 'Cardio', 'Musculação'].map((t) {
                  return _buildChip(t, _tipoSelecionado == t, () => setState(() => _tipoSelecionado = t));
                }).toList(),
              ),
              const SizedBox(height: 24),

              
              _buildTituloSeccao('Quanto tempo tens?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: ['10-20min', '30min', '45+min'].map((t) {
                  return _buildChip(t, _tempoSelecionado == t, () => setState(() => _tempoSelecionado = t));
                }).toList(),
              ),
              const SizedBox(height: 24),

              
              _buildTituloSeccao('Nível de intensidade'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                children: ['Baixo', 'Moderado', 'Intenso'].map((i) {
                  return _buildChip(i, _intensidadeSelecionada == i, () => setState(() => _intensidadeSelecionada = i));
                }).toList(),
              ),
              const SizedBox(height: 24),

              
              _buildTituloSeccao('Onde vais treinar?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: ['Casa(Sem equipamento)', 'Ginásio(Com equipamento)'].map((l) {
                  return _buildChip(l, _localSelecionado == l, () => setState(() => _localSelecionado = l));
                }).toList(),
              ),
              const SizedBox(height: 48),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_estaACaregar || _tipoSelecionado.isEmpty || _tempoSelecionado.isEmpty || _intensidadeSelecionada.isEmpty)
                      ? null // Só deixa avançar se o essencial estiver preenchido
                      : _gerarEIniciarTreino,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2EBF2), // Ciano claro
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0,
                  ),
                  child: _estaACaregar
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('Criar Treino', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTituloSeccao(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  /// Constrói um componente de seleção interativo (Chip).
  ///
  /// * Texto: O rótulo apresentado no chip.
  /// * selecionado: Define o estilo visual (fundo preenchido com borda vs. fundo transparente).
  /// * onTap: A função de _callback_ disparada quando o utilizador toca no elemento.
  Widget _buildChip(String texto, bool selecionado, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFFE0F7FA) : Colors.transparent,
          border: Border.all(
            color: selecionado ? const Color(0xFF4DD0E1) : Colors.transparent,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selecionado ? FontWeight.w500 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}