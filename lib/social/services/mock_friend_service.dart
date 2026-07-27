import '../models/friend_model.dart';
import '../models/achievement_model.dart';

class MockFriendService {
  // ─────────────────────────────────────────────────────────────────
  // DADOS FICTÍCIOS — simulam o que estaria no Firebase
  // ─────────────────────────────────────────────────────────────────

  // Lista de amigos do utilizador actual (em memória)
  final List<FriendModel> _friends = [
    const FriendModel(
      uid: 'uid-arlindo',
      name: 'Arlindo Chicala',
      email: 'arlindo@email.com',
      totalWorkouts: 15,
      streak: 7,
    ),
    const FriendModel(
      uid: 'uid-luis',
      name: 'Luís Ferreira',
      email: 'luis@email.com',
      totalWorkouts: 8,
      streak: 3,
    ),
    const FriendModel(
      uid: 'uid-ana',
      name: 'Ana Silva',
      email: 'ana@email.com',
      totalWorkouts: 22,
      streak: 12,
    ),
  ];

  // Lista de conquistas de amigos (feed social)
  final List<AchievementModel> _achievements = [
    AchievementModel(
      id: 'ach-1',
      userId: 'uid-arlindo',
      userName: 'Arlindo Chicala',
      title: '7 Dias Seguidos!',
      description: 'Treinou 7 dias consecutivos',
      icon: '🔥',
      unlockedAt: DateTime.now().subtract(const Duration(hours: 2)),
      kudosFrom: [],
    ),
    AchievementModel(
      id: 'ach-2',
      userId: 'uid-ana',
      userName: 'Ana Silva',
      title: '20 Treinos Concluídos!',
      description: 'Completou 20 treinos no RealFit',
      icon: '🏆',
      unlockedAt: DateTime.now().subtract(const Duration(hours: 5)),
      kudosFrom: [],
    ),
    AchievementModel(
      id: 'ach-3',
      userId: 'uid-luis',
      userName: 'Luís Ferreira',
      title: 'Primeiro Treino!',
      description: 'Completou o seu primeiro treino',
      icon: '🎯',
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
      kudosFrom: [],
    ),
  ];

  // UID fictício do utilizador actual (será substituído pelo Firebase Auth)
  final String _myUid = 'uid-caram';
  final String _myName = 'Caram';

  // ─────────────────────────────────────────────────────────────────
  // MÉTODOS DE AMIGOS
  // ─────────────────────────────────────────────────────────────────

  // Retorna a lista de amigos.
  // Usamos Future para simular uma chamada assíncrona (como seria com Firebase).
  Future<List<FriendModel>> getFriends() async {
    // Simula um pequeno atraso de rede (0.3 segundos)
    await Future.delayed(const Duration(milliseconds: 300));
    // Retorna uma cópia da lista para evitar modificações acidentais
    return List.from(_friends);
  }

  // Pesquisar utilizador por email.
  // Retorna um FriendModel se encontrar, ou null se não encontrar.
  Future<FriendModel?> searchUserByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simula uma base de dados de utilizadores registados
    final allUsers = [
      const FriendModel(
        uid: 'uid-david',
        name: 'David S.',
        email: 'david@realfit.com',
        totalWorkouts: 30,
        streak: 20,
      ),
      const FriendModel(
        uid: 'uid-maria',
        name: 'Maria João',
        email: 'maria@email.com',
        totalWorkouts: 5,
        streak: 2,
      ),
      ..._friends, // os amigos já existentes também podem ser pesquisados
    ];
    try {
      return allUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null; // firstWhere lança erro se não encontrar — capturamos e retornamos null
    }
  }

  // Verificar se já é amigo.
  Future<bool> isFriend(String friendUid) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _friends.any((f) => f.uid == friendUid);
  }

  // Adicionar amigo.
  Future<void> addFriend(FriendModel friend) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Evita duplicados
    if (!_friends.any((f) => f.uid == friend.uid)) {
      _friends.add(friend);
    }
  }

  // Remover amigo.
  Future<void> removeFriend(String friendUid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _friends.removeWhere((f) => f.uid == friendUid);
  }

  // ─────────────────────────────────────────────────────────────────
  // MÉTODOS DE CONQUISTAS
  // ─────────────────────────────────────────────────────────────────

  // Retorna o feed de conquistas dos amigos (ordenado por data).
  Future<List<AchievementModel>> getFriendAchievements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Ordena do mais recente para o mais antigo
    final sorted = List<AchievementModel>.from(_achievements)
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
    return sorted;
  }

  // Retorna as conquistas de um utilizador específico (para o perfil).
  Future<List<AchievementModel>> getAchievementsOfUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _achievements.where((a) => a.userId == userId).toList();
  }

  // Enviar "Força" a uma conquista.
  Future<void> sendKudos(String achievementId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Encontra a conquista e adiciona o nosso UID à lista kudosFrom
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1) {
      final achievement = _achievements[index];
      // Só adiciona se ainda não enviámos força
      if (!achievement.kudosFrom.contains(_myUid)) {
        _achievements[index] = achievement.copyWith(
          kudosFrom: [...achievement.kudosFrom, _myUid],
        );
      }
    }
  }

  // Verificar se já enviei força a uma conquista.
  bool hasGivenKudos(AchievementModel achievement) {
    return achievement.kudosFrom.contains(_myUid);
  }

  // ─────────────────────────────────────────────────────────────────
  // GETTER úteis
  // ─────────────────────────────────────────────────────────────────

  // UID do utilizador actual
  String get myUid => _myUid;

  // Nome do utilizador actual
  String get myName => _myName;
}
