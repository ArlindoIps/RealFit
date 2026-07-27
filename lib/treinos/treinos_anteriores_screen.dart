import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

/// Ecrã responsável por apresentar os treinos passados do utilizador.
class TreinosAnterioresScreen extends StatefulWidget {
  const TreinosAnterioresScreen({super.key});

  @override
  State<TreinosAnterioresScreen> createState() => _TreinosAnterioresScreenState();
}

class _TreinosAnterioresScreenState extends State<TreinosAnterioresScreen> {
  
  /// Variável de estado que controla qual a lista selecionada.
  bool _mostrarHistorico = true;

  

  @override
  Widget build(BuildContext context) {
    
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
            
            // Desenha a lista Dinâmica (Firebase) ou Estática (Descarregados)
            Expanded(
              child: _mostrarHistorico 
                  ? _buildHistoricoDinamico(uid) 
                  : _buildDescarregadosDinamicos(uid),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a aba de Histórico puxando dados em tempo real do Firebase
  Widget _buildHistoricoDinamico(String? uid) {
    if (uid == null) {
      return const Center(child: Text("Faz login para veres o teu histórico."));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().lerHistoricoTreinos(uid),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF7FE0D0)));
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Ainda não fizeste nenhum treino.\nComeça agora!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        
        return _buildListaCartoes(snapshot.data!, isHistorico: true);
      },
    );
  }
  Widget _buildDescarregadosDinamicos(String? uid) {
    if (uid == null) {
      return const Center(child: Text("Faz login para veres os downloads."));
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().lerTreinosDescarregados(uid),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF7FE0D0)));
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Ainda não tens treinos descarregados.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return _buildListaCartoes(snapshot.data!, isHistorico: false);
      },
    );
  }


  Widget _buildListaCartoes(List<Map<String, dynamic>> listaAtual, {required bool isHistorico}) {
    return ListView.builder(
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
              Text('Nome do treino: ${item['nome'] ?? 'Treino'}', style: const TextStyle(fontSize: 14, height: 1.5)),
              
              if (isHistorico) 
                Text('Duração: ${item['duracao'] ?? '-'}', style: const TextStyle(fontSize: 14, height: 1.5)),
              if (isHistorico)
                Text('Intensidade: ${item['intensidade'] ?? '-'}', style: const TextStyle(fontSize: 14, height: 1.5)),
              
              if (!isHistorico)
                Text('Tamanho do ficheiro: ${item['tamanho'] ?? '-'}', style: const TextStyle(fontSize: 14, height: 1.5)),
              
              Text('Data: ${item['data'] ?? '-'}', style: const TextStyle(fontSize: 14, height: 1.5)),
              
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Aqui futuramente podemos fazer Navigator.push para iniciar o treino de novo
                  },
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
    );
  }
}