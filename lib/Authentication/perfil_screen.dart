import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import 'forgot_screen.dart';
import 'physical_screen.dart';
import 'goal_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color mintColor = Color(0xFF7FE0D0);
  static const Color fieldColor = Color(0xFFF3F3F3);
  static const Color avatarColor = Color(0xFF4A4A4A);

  final AuthService _authService = AuthService();
  File? _profileImage;
  bool _isPickingImage = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  /// Abre a câmara para tirar uma foto e usá-la como foto de perfil.
  ///
  /// NOTA: por agora a imagem só fica guardada localmente durante esta
  /// sessão da app (não persiste depois de fechares a app, nem sincroniza
  /// entre dispositivos). Para persistir a foto de forma permanente,
  /// precisas de adicionar o Firebase Storage ao projeto e fazer upload
  /// do ficheiro para `profile_photos/<uid>.jpg`, guardando depois o URL
  /// resultante no perfil do utilizador na Realtime Database.
  Future<void> _handlePickProfilePhoto() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
      final picker = ImagePicker();
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (photo == null) return; // Utilizador cancelou

      setState(() => _profileImage = File(photo.path));

      // TODO: fazer upload para Firebase Storage e gravar o URL no perfil.
      // Exemplo (depois de adicionares firebase_storage ao pubspec.yaml):
      //
      // final ref = FirebaseStorage.instance
      //     .ref()
      //     .child('profile_photos/${_user!.uid}.jpg');
      // await ref.putFile(_profileImage!);
      // final url = await ref.getDownloadURL();
      // await DatabaseService().updateUserProfile(_user!.uid, {'photoUrl': url});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível aceder à câmara: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    // Não navegamos manualmente: o AuthGate está a ouvir authStateChanges()
    // e vai mostrar o LoginScreen automaticamente assim que o logout for
    // detetado.
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.displayName?.isNotEmpty == true
        ? _user!.displayName!
        : 'Utilizador';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              const Text(
                'Dados Pessoais',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Faça a gestão das suas informações pessoais e '
                'configurações de segurança.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Avatar + nome
              Row(
                children: [
                  GestureDetector(
                    onTap: _handlePickProfilePhoto,
                    child: Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: avatarColor,
                            shape: BoxShape.circle,
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 44,
                                  color: Colors.white24,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: mintColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: _isPickingImage
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: Colors.black87,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'SEGURANÇA DA CONTA',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              _buildTile(
                icon: Icons.shield_outlined,
                title: 'Alterar Palavra Passe',
                subtitle:
                    'Atualize a sua palavra-passe para manter a sua conta segura.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(
                        initialEmail: _user?.email,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildTile(
                icon: Icons.logout,
                title: 'Terminar Sessão',
                subtitle: 'Saia da sua conta neste dispositivo.',
                onTap: _handleLogout,
              ),

              const SizedBox(height: 32),

              const Text(
                'QUESTIONÁRIO',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              _buildTile(
                icon: Icons.fitness_center,
                title: 'Capacidade Física',
                subtitle: 'Atualiza as tuas respostas sobre capacidade física.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PhysicalCapacityScreen(isEditing: true),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildTile(
                icon: Icons.flag_outlined,
                title: 'Objetivo',
                subtitle: 'Muda o teu objetivo principal na app.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoalScreen(isEditing: true),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
          ],
        ),
      ),
    );
  }
}
