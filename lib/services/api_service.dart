import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Função que vai à API buscar os exercícios
  static Future<List<Map<String, dynamic>>> obterTreino(String energia, String tempo) async {
    // 1. Definir quantidade com base no tempo
    int limite = 5; // medio
    if (tempo == 'curto') limite = 3;
    if (tempo == 'longo') limite = 7;

    // 2. Definir categoria da API Wger com base na energia
    // Categorias da Wger: 15=Calves/Stretching, 9=Legs/Cardio, 8=Arms/Chest
    int categoria = 9; 
    if (energia == 'baixa') categoria = 15; 
    if (energia == 'moderada') categoria = 9; 
    if (energia == 'alta') categoria = 8; 

    // URL da API Externa
    final url = Uri.parse('https://wger.de/api/v2/exerciseinfo/?category=$categoria&language=2&limit=$limite');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List resultados = data['results'];

        // Mapear os dados manhosos da API para um formato limpo para a nossa app
        return resultados.map((ex) {
          // Limpar as tags HTML que vêm da descrição da API
          String descricaoLimpa = (ex['description'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '');
          
          return {
            'nome': ex['name'],
            'descricao': descricaoLimpa.isNotEmpty ? descricaoLimpa : 'Siga as instruções com cuidado.',
            // Se a API não tiver imagem, usamos uma imagem estática
            'imagem': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80',
          };
        }).toList();
      }
    } catch (e) {
      print("Erro na API: $e");
    }

    // 3. O PLANO B (Fallback): Se a API falhar por algum motivo, retorna uma lista local!
    return _treinoDeEmergencia(energia, limite);
  }

  // Plano B para garantir que a apresentação não falha
  static List<Map<String, dynamic>> _treinoDeEmergencia(String energia, int limite) {
    List<Map<String, dynamic>> treino = [];
    String nomeEx = energia == 'baixa' ? 'Alongamento Lombar' : (energia == 'moderada' ? 'Burpees' : 'Levantamento de Peso');
    
    for (int i = 0; i < limite; i++) {
      treino.add({
        'nome': '$nomeEx ${i + 1}',
        'descricao': 'Exercício de intensidade $energia gerado localmente.',
        'imagem': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80',
      });
    }
    return treino;
  }
}