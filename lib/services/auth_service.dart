import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  String friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Não existe nenhuma conta com este email.';
      case 'wrong-password':
        return 'Palavra-passe incorreta.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este email.';
      case 'invalid-email':
        return 'O email introduzido não é válido.';
      case 'weak-password':
        return 'A palavra-passe é demasiado fraca (mínimo 6 caracteres).';
      case 'network-request-failed':
        return 'Sem ligação à internet. Tenta novamente.';
      default:
        return 'Ocorreu um erro: ${e.message ?? e.code}';
    }
  }
}
