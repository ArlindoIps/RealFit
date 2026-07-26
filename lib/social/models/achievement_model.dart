// AchievementModel — representa uma conquista desbloqueada
// Dart puro — sem Firebase — não dá erros.

class AchievementModel {
  final String id; // ID único da conquista (ex: "streak_3")
  final String userId; // UID de quem a desbloqueou
  final String userName; // Nome de quem desbloqueou (para o feed)
  final String title; // Título (ex: "3 Dias Seguidos!")
  final String description; // Descrição (ex: "Treinaste 3 dias consecutivos")
  final String icon; // Emoji (ex: "🔥")
  final DateTime unlockedAt; // Quando foi desbloqueada
  final List<String> kudosFrom; // Lista de UIDs que enviaram "Força"

  const AchievementModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedAt,
    this.kudosFrom = const [],
  });

  // Cria uma cópia com o kudosFrom actualizado
  AchievementModel copyWith({List<String>? kudosFrom}) {
    return AchievementModel(
      id: id,
      userId: userId,
      userName: userName,
      title: title,
      description: description,
      icon: icon,
      unlockedAt: unlockedAt,
      kudosFrom: kudosFrom ?? this.kudosFrom,
    );
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map, String id) {
    return AchievementModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '🏆',
      unlockedAt: (map['unlockedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      kudosFrom: List<String>.from(map['kudosFrom'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'title': title,
      'description': description,
      'icon': icon,
      'unlockedAt': unlockedAt,
      'kudosFrom': kudosFrom,
    };
  }
}
