import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'forgot_screen.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
 
  final AuthService _authService = AuthService();
 
  // Cor principal usada nos botões e destaques (mint/turquesa do design)
  static const Color mintColor = Color(0xFF7FE0D0);
  static const Color fieldColor = Color(0xFFF3F3F3);
  static const Color avatarColor = Color(0xFF4A4A4A);
 
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
 
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preenche o email e a palavra-passe.')),
      );
      return;
    }
 
    setState(() => _isLoading = true);
 
    try {
      final user = await _authService.login(email: email, password: password);
      if (!mounted || user == null) return;
 
      // Não navegamos manualmente aqui: o AuthGate (main.dart) está a ouvir
      // authStateChanges() e vai automaticamente mostrar o ecrã certo
      // (questionário ou app principal) assim que este login for detetado.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login efetuado com sucesso!')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.friendlyError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
 
              // Avatar circular
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white24,
                  ),
                ),
              ),
 
              const SizedBox(height: 40),
 
              // Campo Email
              _buildTextField(
                controller: _emailController,
                label: 'Email:',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
 
              const SizedBox(height: 16),
 
              // Campo Palavra Passe
              _buildTextField(
                controller: _passwordController,
                label: 'Palavra Passe:',
                icon: _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                obscureText: _obscurePassword,
                onIconTap: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
 
              const SizedBox(height: 16),
 
              // Lembrar / Esqueceu palavra-passe
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: mintColor,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                  ),
                  const Text('Lembrar', style: TextStyle(fontSize: 15)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueceu Palavra Passe?',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
 
              // Botão Login
              _buildActionButton(
                label: 'Login',
                onPressed: _isLoading ? null : _handleLogin,
                isLoading: _isLoading,
              ),
 
              const SizedBox(height: 16),
 
              // Botão Registar
              _buildActionButton(
                label: 'Registar',
                onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                            ),
                        );
                },
              ),
 
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onIconTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 15,
          ),
          suffixIcon: GestureDetector(
            onTap: onIconTap,
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
        ),
      ),
    );
  }
 
  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: mintColor,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: mintColor.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
 

