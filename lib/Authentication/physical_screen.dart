import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import 'goal_screen.dart';

class PhysicalCapacityScreen extends StatefulWidget {
  /// Quando true, este ecrã é aberto a partir do Perfil para editar
  /// respostas já existentes (em vez do fluxo de onboarding inicial).
  /// Nesse caso, carrega as respostas atuais e, ao gravar, apenas volta
  /// para o ecrã anterior em vez de avançar para o GoalScreen.
  final bool isEditing;
 
  const PhysicalCapacityScreen({super.key, this.isEditing = false});
 
  @override
  State<PhysicalCapacityScreen> createState() =>
      _PhysicalCapacityScreenState();
}
 
class _PhysicalCapacityScreenState extends State<PhysicalCapacityScreen> {
  static const Color mintColor = Color(0xFF7FE0D0);
  static const Color fieldColor = Color(0xFFF3F3F3);
 
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  bool _isLoadingInitialData = false;
 
  // Respostas: true = Sim, false = Não, null = ainda não respondido.
  final Map<String, bool?> _answers = {
    for (final key in PhysicalCapacityQuestions.keys.keys) key: null,
  };
 
  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingAnswers();
    }
  }
 
  Future<void> _loadExistingAnswers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
 
    setState(() => _isLoadingInitialData = true);
 
    try {
      final questionnaire = await _databaseService.getQuestionnaire(user.uid);
      final physicalCapacity =
          questionnaire?['physicalCapacity'] as Map<dynamic, dynamic>?;
 
      if (physicalCapacity != null && mounted) {
        setState(() {
          for (final key in _answers.keys) {
            if (physicalCapacity.containsKey(key)) {
              _answers[key] = physicalCapacity[key] as bool;
            }
          }
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingInitialData = false);
    }
  }
 
  bool get _allAnswered => _answers.values.every((v) => v != null);
 
  Future<void> _handleNext() async {
    if (!_allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Responde a todas as perguntas para continuar.')),
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
      final answers = _answers.map((key, value) => MapEntry(key, value!));
      await _databaseService.savePhysicalCapacity(user.uid, answers);
 
      if (!mounted) return;
 
      if (widget.isEditing) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respostas atualizadas com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoalScreen()),
        );
      }
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
              const SizedBox(height: 24),
 
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Capacidade física do user',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
 
              const SizedBox(height: 24),
 
              // Cabeçalho Sim / Não
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: const [
                    Spacer(),
                    SizedBox(
                      width: 56,
                      child: Text(
                        'Sim',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        'Não',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
 
              const SizedBox(height: 8),
 
              ...PhysicalCapacityQuestions.keys.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildQuestionRow(
                    questionKey: entry.key,
                    label: entry.value,
                  ),
                );
              }),
 
              const SizedBox(height: 16),
 
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleNext,
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
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black87),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.isEditing ? 'Guardar' : 'Seguinte',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (!widget.isEditing) ...const [
                              SizedBox(width: 6),
                              Icon(Icons.chevron_right, size: 22),
                            ],
                          ],
                        ),
                ),
              ),
 
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildQuestionRow({
    required String questionKey,
    required String label,
  }) {
    final currentValue = _answers[questionKey];
 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 56,
            child: Center(
              child: _buildRadioDot(
                selected: currentValue == true,
                onTap: () => setState(() => _answers[questionKey] = true),
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Center(
              child: _buildRadioDot(
                selected: currentValue == false,
                onTap: () => setState(() => _answers[questionKey] = false),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildRadioDot({required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? mintColor : Colors.grey.shade400,
          border: Border.all(
            color: selected ? mintColor : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: Colors.black87)
            : null,
      ),
    );
  }
}

