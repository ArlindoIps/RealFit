import 'dart:convert';
import 'package:http/http.dart' as http;

/// Classe responsável pela comunicação com a API Wger.
///
/// Disponibiliza métodos para obter exercícios através da API externa
/// e, em caso de falha de ligação, gera automaticamente um treino
/// de emergência com exercícios locais.
class ApiService {

  /// Obtém uma lista de exercícios da API Wger.
  ///
  /// O método seleciona a categoria de exercícios e a quantidade de
  /// resultados com base no nível de energia e no tempo disponível
  /// indicados pelo utilizador.
  ///
  /// Caso a API esteja indisponível ou ocorra algum erro durante a
  /// comunicação, é devolvido um treino de emergência gerado localmente.
  ///
  /// [energia] representa o nível de energia do utilizador
  /// ("baixa", "moderada" ou "alta").
  ///
  /// [tempo] representa a duração pretendida do treino
  /// ("curto", "normal" ou "longo").
  ///
  /// Retorna uma lista de exercícios contendo o nome, descrição
  /// e imagem de cada exercício.
  static Future<List<Map<String, dynamic>>> obterTreino(
      String energia, String tempo) async {

    // Definir quantidade de exercícios
    int limite = 5;
    if (tempo == 'curto') limite = 3;
    if (tempo == 'longo') limite = 7;

    // Categorias da API
    int categoria = 9;
    if (energia == 'baixa') categoria = 10;
    if (energia == 'moderada') categoria = 9;
    if (energia == 'alta') categoria = 11;

    final url = Uri.parse(
        'https://wger.de/api/v2/exerciseinfo/?category=$categoria&language=2&limit=$limite');

    try {
      final response = await http.get(url);

      print('--- CHAMADA À API EXTERNA ---');
      print('STATUS: ${response.statusCode}');
      print('DADOS RECEBIDOS: ${response.body}');
      print('-----------------------------');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List resultados = data['results'];

        return resultados.map<Map<String, dynamic>>((ex) {

          String nomeReal = 'Exercício de Força';
          String descricaoLimpa = 'Siga as instruções corretamente.';

          // Procurar a tradução em inglês (language = 2)
          if (ex['translations'] != null &&
              ex['translations'] is List &&
              ex['translations'].isNotEmpty) {

            Map<String, dynamic> traducao = ex['translations'][0];

            for (var t in ex['translations']) {
              if (t['language'] == 2) {
                traducao = t;
                break;
              }
            }

            nomeReal = traducao['name'] ?? nomeReal;

            descricaoLimpa =
                (traducao['description'] ?? '')
                    .replaceAll(RegExp(r'<[^>]*>'), '');

            if (descricaoLimpa.trim().isEmpty) {
              descricaoLimpa = 'Siga as instruções corretamente.';
            }
          }
          
          return {
            'nome': nomeReal,
            'descricao': descricaoLimpa,
            'imagem':
                'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80',
          };
        }).toList();
      }
    } catch (e) {
      print('Erro Crítico na API: $e');
    }

    // Caso a API falhe
    return _treinoDeEmergencia(energia, limite);
  }

  /// Gera um treino local caso a API não esteja disponível.
  ///
  /// Este método garante que a aplicação continua funcional,
  /// criando uma lista de exercícios simples sem necessidade
  /// de ligação à Internet.
  ///
  /// [energia] representa o nível de energia selecionado.
  ///
  /// [limite] corresponde ao número de exercícios a gerar.
  ///
  /// Retorna uma lista de exercícios criada localmente.
  static List<Map<String, dynamic>> _treinoDeEmergencia(
      String energia, int limite) {

    List<Map<String, dynamic>> treino = [];

    String nomeEx = energia == 'baixa'
        ? 'Alongamento Lombar'
        : energia == 'moderada'
            ? 'Burpees'
            : 'Levantamento de Peso';

    for (int i = 0; i < limite; i++) {
      treino.add({
        'nome': '$nomeEx ${i + 1}',
        'descricao':
            'Exercício de intensidade $energia gerado localmente devido a falha de rede.',
        'imagem':
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80',
      });
    }
    
    return treino;
  }
}