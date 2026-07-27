import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../services/mock_friend_service.dart';

class AddFriendScreen extends StatefulWidget {
  // Recebe o service já criado no FriendsScreen (partilha os mesmos dados)
  final MockFriendService service;
  const AddFriendScreen({super.key, required this.service});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _emailCtrl = TextEditingController();

  // Estado deste ecrã
  bool _isSearching = false; // true enquanto pesquisa
  bool _isAdding = false; // true enquanto adiciona
  FriendModel? _result; // utilizador encontrado
  bool _alreadyFriend = false; // já é amigo?
  bool _isMe = false; // é o próprio utilizador?
  String? _error; // mensagem de erro

  @override
  void dispose() {
    _emailCtrl.dispose(); // liberta o controller quando o ecrã é destruído
    super.dispose();
  }

  Future<void> _search() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    // Limpa estado anterior e activa o loading
    setState(() {
      _isSearching = true;
      _result = null;
      _error = null;
      _alreadyFriend = false;
      _isMe = false;
    });

    try {
      final found = await widget.service.searchUserByEmail(email);
      if (found == null) {
        setState(() {
          _error = 'Nenhum utilizador encontrado com este email.';
          _isSearching = false;
        });
        return;
      }
      // Verifica se é o próprio utilizador
      if (found.uid == widget.service.myUid) {
        setState(() {
          _error = 'Não podes adicionar-te a ti mesmo! 😄';
          _isSearching = false;
        });
        return;
      }
      // Verifica se já é amigo
      final already = await widget.service.isFriend(found.uid);
      setState(() {
        _result = found;
        _alreadyFriend = already;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao pesquisar. Verifica a ligação.';
        _isSearching = false;
      });
    }
  }

  Future<void> _addFriend() async {
    if (_result == null) return;
    setState(() => _isAdding = true);
    try {
      await widget.service.addFriend(_result!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_result!.name} adicionado com sucesso! 🎉'),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // volta ao ecrã anterior
      }
    } catch (_) {
      setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Adicionar Amigo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instrução
            const Text(
              'Pesquisa um amigo pelo seu endereço de email:',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Campo de email
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(), // pesquisa ao premir Enter
              decoration: InputDecoration(
                hintText: 'email@exemplo.com',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _emailCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _emailCtrl.clear();
                          setState(() {
                            _result = null;
                            _error = null;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            // Botão pesquisar
            ElevatedButton.icon(
              onPressed: _isSearching ? null : _search,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4C8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isSearching
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(_isSearching ? 'A pesquisar...' : 'Pesquisar'),
            ),
            const SizedBox(height: 24),

            // Mensagem de erro
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFB71C1C)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Color(0xFFB71C1C)),
                      ),
                    ),
                  ],
                ),
              ),

            // Resultado da pesquisa
            if (_result != null) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFF00B4C8),
                        child: Text(
                          _result!.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _result!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _result!.email,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 18,
                          ),
                          Text(
                            ' ${_result!.streak} dias  ',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const Icon(
                            Icons.fitness_center,
                            color: Colors.grey,
                            size: 18,
                          ),
                          Text(
                            ' ${_result!.totalWorkouts} treinos',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_alreadyFriend)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Já são amigos ✓',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isAdding ? null : _addFriend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B4C8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: _isAdding
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.person_add),
                            label: Text(
                              _isAdding ? 'A adicionar...' : 'Adicionar Amigo',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],

            // Dica de emails para testar
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emails de teste:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF006064),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('david@realfit.com', style: TextStyle(fontSize: 12)),
                  Text('maria@email.com', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
