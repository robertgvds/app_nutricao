import 'package:flutter/material.dart';
import '../../../classes/usuario.dart';
import '../../../database/usuario_repository.dart'; // Necessário para buscar o usuário base
import '../../../database/nutricionista_repository.dart';
import '../../../database/paciente_repository.dart';

enum TipoPerfil { nutricionista, paciente }

class EvolucaoUsuarioPage extends StatefulWidget {
  const EvolucaoUsuarioPage({Key? key}) : super(key: key);

  @override
  State<EvolucaoUsuarioPage> createState() => _EvolucaoUsuarioPageState();
}

class _EvolucaoUsuarioPageState extends State<EvolucaoUsuarioPage> {
  // Controladores
  final _idUsuarioController = TextEditingController(); // Novo: ID digitado
  final _dadoExtraController = TextEditingController(); // CRN ou CRN Nutri

  // Repositórios
  final _repoUsuario =
      UsuarioRepository(); // Novo: Para buscar o usuário inicial
  final _repoNutri = NutricionistaRepository();
  final _repoPaciente = PacienteRepository();

  // Estado
  Usuario? _usuarioEncontrado; // Armazena o usuário se o ID for válido
  TipoPerfil? _perfilSelecionado;
  bool _isLoading = false;

  @override
  void dispose() {
    _idUsuarioController.dispose();
    _dadoExtraController.dispose();
    super.dispose();
  }

  // --- 1. FUNÇÃO PARA BUSCAR O USUÁRIO PELO ID ---
  void _buscarUsuario() async {
    // Limpa estado anterior
    setState(() {
      _usuarioEncontrado = null;
      _perfilSelecionado = null;
      _dadoExtraController.clear();
    });
    FocusScope.of(context).unfocus(); // Fecha teclado

    final String idText = _idUsuarioController.text;
    if (idText.isEmpty) {
      _mostrarSnack('Digite um ID para buscar.', Colors.orange);
      return;
    }

    final int? id = int.tryParse(idText);
    if (id == null) {
      _mostrarSnack('O ID deve ser numérico.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Tenta encontrar na tabela de usuários "comuns" (não evoluídos)
      // Nota: Você precisa ter um método 'buscarPorId' no UsuarioRepository
      // que busque APENAS na tabela 'usuarios'.
      final List<Usuario> usuarios = await _repoUsuario.listar();
      // O ideal seria um método buscarPorId específico, mas vamos filtrar a lista para garantir:

      try {
        final usuarioEncontrado = usuarios.firstWhere((u) => u.id == id);
        setState(() {
          _usuarioEncontrado = usuarioEncontrado;
        });
        _mostrarSnack(
          'Usuário ${usuarioEncontrado.nome} encontrado!',
          Colors.green,
        );
      } catch (e) {
        _mostrarSnack(
          'Usuário com ID $id não encontrado ou já evoluído.',
          Colors.red,
        );
      }
    } catch (e) {
      _mostrarSnack('Erro ao buscar: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. FUNÇÃO DE EVOLUÇÃO (Mantida, mas usando _usuarioEncontrado) ---
  void _confirmarEvolucao() async {
    FocusScope.of(context).unfocus();

    if (_usuarioEncontrado == null) return;

    if (_perfilSelecionado == null) {
      _mostrarSnack('Selecione o tipo de perfil.', Colors.orange);
      return;
    }
    if (_dadoExtraController.text.trim().isEmpty) {
      _mostrarSnack('Campo obrigatório vazio.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final int idUsuario = _usuarioEncontrado!.id!;
      final String dadoExtra = _dadoExtraController.text.trim();

      if (_perfilSelecionado == TipoPerfil.nutricionista) {
        await _repoNutri.evoluirDeUsuario(idUsuario, dadoExtra);
        _mostrarSnack('Evoluído para Nutricionista com sucesso!', Colors.green);
      } else {
        await _repoPaciente.evoluirDeUsuario(idUsuario, dadoExtra);
        _mostrarSnack('Evoluído para Paciente com sucesso!', Colors.green);
      }

      if (!mounted) return;
      // Reseta a tela para permitir nova evolução ou sai
      setState(() {
        _idUsuarioController.clear();
        _usuarioEncontrado = null;
        _perfilSelecionado = null;
        _dadoExtraController.clear();
      });
    } catch (e) {
      _mostrarSnack('Erro na evolução: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarSnack(String msg, Color cor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: cor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atribuir Perfil"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- ÁREA DE BUSCA ---
            const Text(
              "Buscar Usuário Pendente",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idUsuarioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID do Usuário',
                      hintText: 'Ex: 1',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _buscarUsuario,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Icons.check, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- ÁREA DE RESULTADO (Só aparece se encontrou usuário) ---
            if (_usuarioEncontrado != null) ...[
              Card(
                color: Colors.green[50],
                child: ListTile(
                  leading: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.green,
                  ),
                  title: Text(
                    _usuarioEncontrado!.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_usuarioEncontrado!.email),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Selecione o destino:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              RadioListTile<TipoPerfil>(
                title: const Text("Nutricionista"),
                subtitle: const Text("Requer CRN"),
                value: TipoPerfil.nutricionista,
                groupValue: _perfilSelecionado,
                onChanged:
                    (val) => setState(() {
                      _perfilSelecionado = val;
                      _dadoExtraController.clear();
                    }),
              ),
              RadioListTile<TipoPerfil>(
                title: const Text("Paciente"),
                subtitle: const Text("Requer CRN do Nutricionista"),
                value: TipoPerfil.paciente,
                groupValue: _perfilSelecionado,
                onChanged:
                    (val) => setState(() {
                      _perfilSelecionado = val;
                      _dadoExtraController.clear();
                    }),
              ),

              const SizedBox(height: 20),

              // Campo Condicional
              if (_perfilSelecionado != null)
                TextField(
                  controller: _dadoExtraController,
                  decoration: InputDecoration(
                    labelText:
                        _perfilSelecionado == TipoPerfil.nutricionista
                            ? 'CRN do Profissional'
                            : 'CRN do Nutricionista Responsável',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _confirmarEvolucao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("CONCLUIR EVOLUÇÃO"),
              ),
            ] else if (!_isLoading &&
                _idUsuarioController.text.isNotEmpty &&
                _usuarioEncontrado == null) ...[
              // Feedback visual se buscou e não achou
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Nenhum usuário pendente encontrado com este ID.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
