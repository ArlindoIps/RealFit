import 'package:firebase_database/firebase_database.dart';

/// Modelo simples do perfil de utilizador guardado na Realtime Database.
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final int createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}

/// Serviço responsável por ler/escrever dados na Firebase Realtime Database.
///
/// Estrutura dos dados no Realtime Database:
/// {
///   "users": {
///     "<uid>": {
///       "uid": "...",
///       "name": "...",
///       "email": "...",
///       "createdAt": 1721472000000
///     }
///   }
/// }
class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  DatabaseReference get _usersRef => _db.child('users');

  /// Cria/atualiza o perfil do utilizador depois do registo.
  Future<void> createUserProfile(UserProfile profile) async {
    await _usersRef.child(profile.uid).set(profile.toMap());
  }

  /// Vai buscar o perfil de um utilizador pelo uid.
  Future<UserProfile?> getUserProfile(String uid) async {
    final snapshot = await _usersRef.child(uid).get();
    if (!snapshot.exists) return null;
    return UserProfile.fromMap(snapshot.value as Map<dynamic, dynamic>);
  }

  /// Ouve alterações em tempo real ao perfil do utilizador
  /// (por exemplo, para refletir mudanças feitas noutro dispositivo).
  Stream<UserProfile?> watchUserProfile(String uid) {
    return _usersRef.child(uid).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return null;
      return UserProfile.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    await _usersRef.child(uid).update(updates);
  }

  Future<void> deleteUserProfile(String uid) async {
    await _usersRef.child(uid).remove();
  }

  // ---------------------------------------------------------------------
  // Questionário de onboarding (Capacidade Física + Objetivo)
  // ---------------------------------------------------------------------
  //
  // Estrutura gravada:
  // users/<uid>/questionnaire/
  //   physicalCapacity: { "ja_treinaste": true, "passas_muito_tempo_sentado": false, ... }
  //   goal: "Ficar em Forma"
  //   completedAt: 1721840000000

  DatabaseReference _questionnaireRef(String uid) =>
      _usersRef.child(uid).child('questionnaire');

  /// Guarda as respostas Sim/Não da "Capacidade física do user".
  /// [answers] deve usar as chaves definidas em [PhysicalCapacityQuestions.keys].
  Future<void> savePhysicalCapacity(
    String uid,
    Map<String, bool> answers,
  ) async {
    await _questionnaireRef(uid).child('physicalCapacity').set(answers);
  }

  /// Guarda o objetivo escolhido pelo utilizador.
  Future<void> saveGoal(String uid, String goal) async {
    await _questionnaireRef(uid).update({
      'goal': goal,
      'completedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Verifica se o utilizador já preencheu o questionário completo
  /// (usado para decidir se mostramos o onboarding ou vamos direto para a Home).
  Future<bool> hasCompletedQuestionnaire(String uid) async {
    final snapshot = await _questionnaireRef(uid).child('completedAt').get();
    return snapshot.exists;
  }

  /// Vai buscar o questionário completo de um utilizador.
  Future<Map<String, dynamic>?> getQuestionnaire(String uid) async {
    final snapshot = await _questionnaireRef(uid).get();
    if (!snapshot.exists) return null;
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  /// Grava um treino iniciado no histórico do utilizador
  Future<void> salvarTreinoNoHistorico(String uid, String nome, String duracao, String intensidade) async {
    // O .push() cria um ID único e aleatório para este treino específico
    final novoTreinoRef = _usersRef.child(uid).child('historico').push();
    
    final dataAtual = "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}";

    await novoTreinoRef.set({
      'nome': nome,
      'duracao': duracao,
      'intensidade': intensidade,
      'data': dataAtual,
      // Guardamos também um timestamp real do servidor para conseguirmos ordenar do mais recente para o mais antigo depois
      'timestamp': ServerValue.timestamp, 
    });
  }

  Stream<List<Map<String, dynamic>>> lerHistoricoTreinos(String uid) {
    return _usersRef.child(uid).child('historico').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return []; 

      List<Map<String, dynamic>> listaHistorico = [];
      data.forEach((key, value) {
        listaHistorico.add(Map<String, dynamic>.from(value as Map));
      });

      
      listaHistorico.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
      
      return listaHistorico;
    });
  }

  Future<void> salvarTreinoDescarregado(String uid, String nome, String tamanho) async {
    final novoDownloadRef = _usersRef.child(uid).child('descarregados').push();
    
    final dataAtual = "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}";

    await novoDownloadRef.set({
      'nome': nome,
      'tamanho': tamanho, 
      'data': dataAtual,
      'timestamp': ServerValue.timestamp,
    });
  }

  
  Stream<List<Map<String, dynamic>>> lerTreinosDescarregados(String uid) {
    return _usersRef.child(uid).child('descarregados').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      List<Map<String, dynamic>> listaDescarregados = [];
      data.forEach((key, value) {
        listaDescarregados.add(Map<String, dynamic>.from(value as Map));
      });

      listaDescarregados.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
      return listaDescarregados;
    });
  }
  Future<void> notificarAmigosTreinoConcluido(String meuUid, String meuNome, String nomeTreino) async {
    
    final amigosSnapshot = await _usersRef.child(meuUid).child('amigos').get();
    
    if (amigosSnapshot.exists) {
      final amigosMap = amigosSnapshot.value as Map<dynamic, dynamic>;
      final dataAtual = "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}";
      
      amigosMap.forEach((amigoUid, _) async {
        await _usersRef.child(amigoUid.toString()).child('notificacoes').push().set({
          'titulo': 'Treino Concluído! 🔥',
          'mensagem': '$meuNome acabou de completar o treino: $nomeTreino. Envia-lhe os parabéns!',
          'data': dataAtual,
          'timestamp': ServerValue.timestamp,
        });
      });
    }
  }

  /// Ouve as notificações do utilizador em tempo real
  Stream<List<Map<String, dynamic>>> lerNotificacoes(String uid) {
    return _usersRef.child(uid).child('notificacoes').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      List<Map<String, dynamic>> listaNotificacoes = [];
      data.forEach((key, value) {
        listaNotificacoes.add(Map<String, dynamic>.from(value as Map));
      });

      // Ordena da mais recente para a mais antiga
      listaNotificacoes.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
      return listaNotificacoes;
    });
  }
  /// Pesquisa um utilizador pelo email exato
  Future<UserProfile?> searchUserByEmail(String email) async {
    final snapshot = await _usersRef.get();
    if (!snapshot.exists) return null;

    final data = snapshot.value as Map<dynamic, dynamic>;
    for (var entry in data.entries) {
      final userMap = Map<String, dynamic>.from(entry.value as Map);
      if (userMap['email'] == email) {
        return UserProfile.fromMap(userMap);
      }
    }
    return null;
  }

  /// Adiciona o UID de um utilizador à tua lista de amigos
  Future<void> addFriend(String meuUid, String amigoUid) async {
    
    await _usersRef.child(meuUid).child('amigos').child(amigoUid).set(true);
    // Guarda na pasta do amigo que ele é teu amigo (Amizade mútua instantânea para simplificar)
    await _usersRef.child(amigoUid).child('amigos').child(meuUid).set(true);
  }
}

/// Perguntas fixas do ecrã "Capacidade física do user".
/// Mantidas centralizadas para reutilizar as mesmas chaves na UI e na
/// gravação em Firebase.
class PhysicalCapacityQuestions {
  static const Map<String, String> keys = {
    'ja_treinaste': 'Já treinaste alguma vez?',
    'passas_muito_tempo_sentado': 'Passas muito tempo sentado?',
    'toma_suplemento': 'Toma algum suplemento?',
    'dieta_equilibrada': 'Tens dieta equilibrada?',
    'dores_frequentes': 'Sentes dores frequentes em alguma parte do corpo?',
    'lesao_ou_limitacao': 'Já teve alguma lesão ou limitação física?',
  };
}

/// Opções fixas do ecrã "Qual é o seu objetivo".
class GoalOptions {
  static const List<String> options = [
    'Ficar em Forma',
    'Perder Peso',
    'Construir Musculos',
    'Melhorar a postura e flexibilidade',
    'Reduzir o Stress e Ansiedade',
  ];
}
