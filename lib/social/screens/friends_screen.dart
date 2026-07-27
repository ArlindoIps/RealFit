import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../models/achievement_model.dart';
import '../services/mock_friend_service.dart';
import 'add_friend_screen.dart';
import 'friend_profile_screen.dart';

// StatefulWidget porque tem estado interno (o TabController e os dados)
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin é necessário para o TabController funcionar.
  // Fornece o "vsync" que sincroniza as animações com o ecrã.

  late TabController _tabController;
  // "late" significa: vou inicializar isto no initState, não aqui.

  // O nosso serviço de dados (sem Firebase)
  final MockFriendService _service = MockFriendService();

  // Estado da lista de amigos
  List<FriendModel> _friends = [];
  bool _loadingFriends = true;

  // Estado das conquistas
  List<AchievementModel> _achievements = [];
  bool _loadingAchievements = true;

  @override
  void initState() {
    super.initState();
    // Cria o TabController com 2 abas
    _tabController = TabController(length: 2, vsync: this);
    // Carrega os dados quando o ecrã abre
    _loadData();
  }

  // Carrega amigos e conquistas ao mesmo tempo
  Future<void> _loadData() async {
    // Carrega amigos
    final friends = await _service.getFriends();
    // Carrega conquistas
    final achievements = await _service.getFriendAchievements();
    // Actualiza o estado — isto reconstrói o widget
    if (mounted) {
      // "mounted" verifica se o widget ainda está na árvore
      // (protecção para evitar erros se o utilizador sair do ecrã antes de carregar)
      setState(() {
        _friends = friends;
        _loadingFriends = false;
        _achievements = achievements;
        _loadingAchievements = false;
      });
    }
  }

  @override
  void dispose() {
    // IMPORTANTE: libertar o TabController quando o ecrã é destruído
    // Se não fizeres isto, há um "memory leak" (fuga de memória)
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Social',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // TabBar dentro da AppBar — cria os botões Amigos/Conquistas
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00B4C8),
          labelColor: const Color(0xFF00B4C8),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Amigos'),
            Tab(text: 'Conquistas'),
          ],
        ),
        // Botão "+" no canto direito para adicionar amigo
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_outlined,
              color: Color(0xFF00B4C8),
            ),
            tooltip: 'Adicionar Amigo',
            onPressed: () async {
              // Vai para o ecrã de adicionar amigo
              // "await" espera que o utilizador volte
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddFriendScreen(service: _service),
                ),
              );
              // Quando volta, recarrega a lista de amigos
              _loadData();
            },
          ),
        ],
      ),
      // TabBarView — o conteúdo de cada aba
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(), // Aba 0 — lista de amigos
          _buildAchievementsTab(), // Aba 1 — feed de conquistas
        ],
      ),
    );
  }

  // ─────────────── ABA 1: LISTA DE AMIGOS ───────────────────────
  Widget _buildFriendsTab() {
    // Se ainda está a carregar, mostra um spinner
    if (_loadingFriends) {
      return const Center(child: CircularProgressIndicator());
    }
    // Se a lista está vazia, mostra mensagem de estado vazio
    if (_friends.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Ainda não tens amigos no RealFit.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Usa o + para adicionar amigos!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    // Lista de amigos
    return RefreshIndicator(
      // Puxa para baixo para recarregar
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return _FriendCard(
            friend: _friends[index],
            service: _service,
            onRemoved: _loadData, // recarrega depois de remover
            onViewProfile: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FriendProfileScreen(
                  friend: _friends[index],
                  service: _service,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────── ABA 2: FEED DE CONQUISTAS ────────────────────
  Widget _buildAchievementsTab() {
    if (_loadingAchievements) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_achievements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'As conquistas dos teus amigos',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text('aparecem aqui.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _achievements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return _AchievementCard(
            achievement: _achievements[index],
            service: _service,
            // Quando o utilizador envia força, recarrega o feed
            onKudosSent: _loadData,
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// WIDGET: Card de um amigo
// ══════════════════════════════════════════════════════════════════
class _FriendCard extends StatelessWidget {
  final FriendModel friend;
  final MockFriendService service;
  final VoidCallback onRemoved;
  final VoidCallback onViewProfile;

  const _FriendCard({
    required this.friend,
    required this.service,
    required this.onRemoved,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coluna esquerda: avatar + stats + lixo (como no Figma)
            Column(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF00B4C8),
                  child: Text(
                    friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${friend.totalWorkouts} treinos',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  'Streak: ${friend.streak} dias',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _confirmRemove(context),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Centro: texto de actividade do amigo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _getActivityText(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A1A2E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            // Direita: ícone de olho
            IconButton(
              icon: const Icon(
                Icons.visibility_outlined,
                color: Color(0xFF00B4C8),
              ),
              onPressed: onViewProfile,
            ),
          ],
        ),
      ),
    );
  }

  // Texto de actividade simulado baseado nos dados do amigo
  String _getActivityText() {
    if (friend.totalWorkouts == 0) return 'Sem atividade recente!';
    if (friend.streak >= 7)
      return '${friend.name.split(' ').first} está em chama! 🔥 ${friend.streak} dias seguidos';
    return '${friend.name.split(' ').first} concluiu um treino recentemente!';
  }

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover Amigo'),
        content: Text('Queres mesmo remover ${friend.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await service.removeFriend(friend.uid);
              onRemoved();
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// WIDGET: Card de uma conquista no feed
// ══════════════════════════════════════════════════════════════════
class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final MockFriendService service;
  final VoidCallback onKudosSent;

  const _AchievementCard({
    required this.achievement,
    required this.service,
    required this.onKudosSent,
  });

  @override
  Widget build(BuildContext context) {
    final alreadyGaveKudos = service.hasGivenKudos(achievement);
    final kudosCount = achievement.kudosFrom.length;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Emoji da conquista
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Informação da conquista
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    achievement.title,
                    style: const TextStyle(
                      color: Color(0xFF00B4C8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    achievement.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  // Tempo desde que foi desbloqueada
                  Text(
                    _timeAgo(achievement.unlockedAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            // Botão Enviar Força
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    alreadyGaveKudos ? Icons.favorite : Icons.favorite_border,
                    color: alreadyGaveKudos ? Colors.red : Colors.grey,
                    size: 22,
                  ),
                  // Se já enviou força, o botão fica desactivado
                  onPressed: alreadyGaveKudos
                      ? null
                      : () async {
                          await service.sendKudos(achievement.id);
                          onKudosSent();
                        },
                ),
                if (kudosCount > 0)
                  Text(
                    '$kudosCount',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calcula há quanto tempo foi desbloqueada a conquista
  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} minutos';
    if (diff.inHours < 24) return 'há ${diff.inHours} horas';
    return 'há ${diff.inDays} dias';
  }
}
