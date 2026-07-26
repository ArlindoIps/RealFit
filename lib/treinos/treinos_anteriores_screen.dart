import 'package:flutter/material.dart';

/// Ecrã responsável por apresentar os treinos passados do utilizador.
///
/// Este ecrã permite alternar entre duas visualizações:
/// 1. O histórico de treinos já realizados.
/// 2. Os treinos descarregados para acesso offline.
class TreinosAnterioresScreen extends StatefulWidget {
  const TreinosAnterioresScreen({super.key});

  @override
  State<TreinosAnterioresScreen> createState() => _TreinosAnterioresScreenState();
}

class _TreinosAnterioresScreenState extends State<TreinosAnterioresScreen> {
  
  /// Variável de estado que controla qual a lista selecionada.
  /// Se for [true], apresenta o Histórico. Se for [false], apresenta os Descarregados.
  bool _mostrarHistorico = true;

  // Dados provisórios para o Histórico 
  final List<Map<String, String>> _historico = [
    {
      'nome': 'Mega Braços',
      'duracao': '40min',
      'intensidade': 'Moderado',
      'data': '20-12-2025',
    },
    {
      'nome': 'Treino de pernas',
      'duracao': '20min',
      'intensidade': 'Baixa',
      'data': '21-09-2025',
    },
    {
      'nome': 'Flexibilidade de ombros',
      'duracao': '15min',
      'intensidade': 'Baixa',
      'data': '08-12-2025',
    },
  ];

  
  final List<Map<String, String>> _descarregados = [
    {
      'nome': 'Mega Braços',
      'tamanho': '200MB',
      'data': '20-12-2025',
    },
    {
      'nome': 'Treino de pernas',
      'tamanho': '120MB',
      'data': '21-09-2025',
    },
    {
      'nome': 'Flexibilidade de ombros',
      'tamanho': '300MB',
      'data': '08-12-2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    
    final listaAtual = _mostrarHistorico ? _historico : _descarregados;

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
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Os botões de alternar (Toggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                GestureDetector(
                  onTap: () => setState(() => _mostrarHistorico = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _mostrarHistorico ? Colors.black38 : Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Histórico',
                      style: TextStyle(
                        fontWeight: _mostrarHistorico ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => _mostrarHistorico = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: !_mostrarHistorico ? Colors.black38 : Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Descarregados',
                      style: TextStyle(
                        fontWeight: !_mostrarHistorico ? FontWeight.bold : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: listaAtual.length,
                itemBuilder: (context, index) {
                  final item = listaAtual[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nome do treino: ${item['nome']}', style: const TextStyle(fontSize: 14, height: 1.5)),
                        if (_mostrarHistorico) 
                          Text('Duração: ${item['duracao']}', style: const TextStyle(fontSize: 14, height: 1.5)),
                        if (_mostrarHistorico)
                          Text('Intensidade: ${item['intensidade']}', style: const TextStyle(fontSize: 14, height: 1.5)),
                        if (!_mostrarHistorico)
                          Text('Tamanho do ficheiro : ${item['tamanho']}', style: const TextStyle(fontSize: 14, height: 1.5)),
                        Text('Data: ${item['data']}', style: const TextStyle(fontSize: 14, height: 1.5)),
                        
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE0F7FA), // Ciano muito claro
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text('Iniciar treino', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}