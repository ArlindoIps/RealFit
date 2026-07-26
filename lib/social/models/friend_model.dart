// FriendModel — é a classe que representa um amigo na app RealFit
class FriendModel {
  final String uid; // Identificador único do utilizador
  final String name; // Nome de exibição
  final String email; // Email (usado para pesquisa)
  final int totalWorkouts; // Quantos treinos já completou
  final int streak; // Quantos dias seguidos de treino

  // Constructor — como se cria um FriendModel
  const FriendModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.totalWorkouts,
    required this.streak,
  });

  // fromMap: converte um Map (do Firestore) num FriendModel.
  // Vai ser usado DEPOIS quando o Firebase estiver ligado.
  factory FriendModel.fromMap(Map<String, dynamic> map, String uid) {
    return FriendModel(
      uid: uid,
      name: map['name'] ?? 'Utilizador',
      email: map['email'] ?? '',
      totalWorkouts: (map['totalWorkouts'] ?? 0) as int,
      streak: (map['streak'] ?? 0) as int,
    );
  }

  // toMap: converte o FriendModel num Map para guardar no Firestore.
  // Vai ser usado DEPOIS quando o Firebase estiver ligado.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'totalWorkouts': totalWorkouts,
      'streak': streak,
    };
  }
}
