import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import 'auth_gate.dart';

class GoalScreen extends StatefulWidget {
  /// Quando true, este ecrã é aberto a partir do Perfil para editar o
  /// objetivo já escolhido, em vez do fluxo de onboarding inicial.
  final bool isEditing;
 
  const GoalScreen({super.key, this.isEditing = false});
 
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}
 
class _GoalScreenState extends State<GoalScreen> {
  static const Color mintColor = Color(0xFF7FE0D0);
  static const Color fieldColor = Color(0xFFF3F3F3);
 
  final DatabaseService _databaseService = DatabaseService();
  String? _selectedGoal;
  bool _isLoading = false;
  bool _isLoadingInitialData = false;
 
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingGoal();
    }
  }
 
  Future<void> _loadExistingGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
 
    setState(() => _isLoadingInitialData = true);
 
    try {
      final questionnaire = await _databaseService.getQuestionnaire(user.uid);
      final goal = questionnaire?['goal'] as String?;
 
      if (goal != null && mounted) {
        setState(() => _selectedGoal = goal);
      }
    } finally {
      if (mounted) setState(() => _isLoadingInitialData = false);
    }
  }
 
  Future<void> _handleContinue() async {
    if (_selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolhe um objetivo para continuar.')),
      );
      return;
    }
 
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão inválida. Faz login novamente.')),
      );
      return;
    }
 
    setState(() => _isLoading = true);
 
    try {
      await _databaseService.saveGoal(user.uid, _selectedGoal!);
 
      if (!mounted) return;
 
      if (widget.isEditing) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objetivo atualizado com sucesso!')),
        );
        Navigator.pop(context);
        return;
      }
 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil e objetivo guardados com sucesso!')),
      );
      // Pede ao AuthGate para reavaliar hasCompletedQuestionnaire (agora true)
      // e volta para a raiz da app — o AuthGate vai então mostrar o
      // MainNavegacao automaticamente.
      AuthGate.refresh();
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    if (_isLoadingInitialData) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
 
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
 
              const Text(
                'Qual é o seu objetivo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
 
              const SizedBox(height: 16),
 
              const Text(
                'O que te traz ao RealFit? Define o teu objetivo principal '
                'para começarmos a construir a tua rotina de exercícios '
                'personalizada.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
 
              const SizedBox(height: 32),
 
              ...GoalOptions.options.map((goal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildGoalOption(goal),
                );
              }),
 
              const SizedBox(height: 24),
 
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: mintColor,
                          foregroundColor: Colors.black87,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mintColor,
                          foregroundColor: Colors.black87,
                          disabledBackgroundColor: mintColor.withOpacity(0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black87),
                                ),
                              )
                            : Text(
                                widget.isEditing ? 'Guardar' : 'Continuar',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildGoalOption(String goal) {
    final isSelected = _selectedGoal == goal;
 
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = goal),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? mintColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                goal,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? mintColor : Colors.grey.shade400,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.black87)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
