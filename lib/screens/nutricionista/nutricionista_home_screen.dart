import 'package:app/screens/nutricionista/nutricionista_historico_planos_screen.dart';
import 'package:app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../classes/nutricionista.dart';
import '../../database/nutricionista_repository.dart';
import '../../database/paciente_repository.dart';
import '../../classes/paciente.dart';
import 'nutricionista_antropometria_screen.dart';


class NutricionistaHomeScreen extends StatefulWidget {
  final String nutriId;
  final Function(int) onMudarAba;

  const NutricionistaHomeScreen({
    super.key,
    required this.nutriId,
    required this.onMudarAba,
  });

  @override
  State<NutricionistaHomeScreen> createState() =>
      _NutricionistaHomeScreenState();
}

class _NutricionistaHomeScreenState extends State<NutricionistaHomeScreen> {
  final _nutriRepo = NutricionistaRepository();
  final _pacienteRepo = PacienteRepository();

  Nutricionista? _nutricionista;
  List<Paciente> _meusPacientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    try {
      final nutri = await _nutriRepo.buscarPorId(widget.nutriId);
      final todosPacientes = await _pacienteRepo.listar();

      if (mounted) {
        setState(() {
          _nutricionista = nutri;

          if (_nutricionista != null) {
            _meusPacientes = todosPacientes
                .where((p) => p.id != null && _nutricionista!.pacientesIds.contains(p.id))
                .toList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- MÉTODO DE TESTE ---
  // Busca o paciente pelo ID e abre a tela de Plano Alimentar
  Future<void> _abrirTestePlanoAlimentar(String pacienteId) async {
    // Mostra loading rápido
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pacienteTeste = await _pacienteRepo.buscarPorId(pacienteId);
      
      // Fecha o loading
      if (mounted) Navigator.pop(context);

      if (pacienteTeste != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NutricionistaHistoricoPlanosScreen(
                paciente: pacienteTeste,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Paciente de teste não encontrado no banco.")),
          );
        }
      }
    } catch (e) {
      // Fecha loading se der erro
      if (mounted) Navigator.pop(context);
      debugPrint("Erro teste: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.laranja,
      
      // --- BOTÃO DE TESTE ATUALIZADO ---
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.laranja,
        icon: const Icon(Icons.restaurant_menu), // Ícone de comida
        label: const Text("Testar Plano Alimentar"),
        onPressed: () {
          // Busca o paciente e abre a tela de DIETA
          _abrirTestePlanoAlimentar("uGFqVcMBdNVRQzaWs0cnmlSlBmw2");
        },
      ),
      
      appBar: AppBar(
        backgroundColor: AppColors.laranja,
        elevation: 0,
        title: const Text('Mango Nutri', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  const Divider(),
                  _buildSecaoTitulo(
                    "Avaliações Pendentes",
                    const Color(0xFF916DD5),
                  ),

                  if (_meusPacientes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("Nenhum paciente vinculado.")),
                    )
                  else
                    ..._meusPacientes
                        .where((p) => p.antropometria == null)
                        .map((p) => _cardAvaliacaoPendente(p)),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              const TextSpan(text: "Olá, "),
              TextSpan(
                text: _nutricionista?.nome ?? "Nutri",
                style: const TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        Text("Pacientes ativos: ${_meusPacientes.length}"),
        Text(
          "CRN: ${_nutricionista?.crn ?? "N/A"}",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _cardAvaliacaoPendente(Paciente paciente) {
    final antro = paciente.antropometria;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paciente.nome,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            antro == null
                ? "Sem Avaliações"
                : "Última Avaliação: ${antro.data}",
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF87EF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.assignment_add, size: 18),
              label: const Text("Adicionar Avaliação"),
              onPressed: () {
                if (paciente.id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NutricionistaAntropometriaScreen(
                        pacienteId: paciente.id!,
                      ),
                    ),
                  ).then((_) => _carregarDados());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoTitulo(String t, Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Text(
      t,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c),
    ),
  );
}