import 'package:app/screens/paciente/paciente_navigation.dart';
import 'package:app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/auth_service.dart';
import '../../classes/antropometria.dart';
import '../../database/antropometria_repository.dart';
import '../../database/paciente_repository.dart';
import '../../classes/paciente.dart';
import '../../classes/refeicao.dart';
import '../../classes/nutricionista.dart';
import '../../database/nutricionista_repository.dart';

class HomeTabScreen extends StatefulWidget {
  final String pacienteId;
  final Function(int) onMudarAba;

  const HomeTabScreen({
    super.key, 
    required this.pacienteId,
    required this.onMudarAba,
  });
  
  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  List<Refeicao> _planoAlimentar = [];
  final _antropometriaRepo = AntropometriaRepository();
  final _pacienteRepo = PacienteRepository();
  final _nutriRepo = NutricionistaRepository();
  Antropometria? _ultimaAvaliacao;
  Paciente? _paciente;
  Nutricionista? _nutricionista;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosHome();
  }

  Future<void> _carregarDadosHome() async {
    try {
      final _nutriRepo = NutricionistaRepository();
      final resultados = await Future.wait([
        _antropometriaRepo.buscarHistorico(widget.pacienteId),
        _pacienteRepo.buscarPorId(widget.pacienteId),
      ]);

      final historico = resultados[0] as List<Antropometria>;
      final pacienteEncontrado = resultados[1] as Paciente?;
      final refeicoesEncontradas = resultados[2] as List<Refeicao>;

      Nutricionista? nutricionistaEncontrado;
      if (pacienteEncontrado != null &&
          pacienteEncontrado.nutricionistaCrn != null &&
          pacienteEncontrado.nutricionistaCrn!.isNotEmpty) {
        nutricionistaEncontrado = await _nutriRepo.buscarPorCRN(
          pacienteEncontrado.nutricionistaCrn!,
        );
      }

      setState(() {
        _paciente = pacienteEncontrado;
        _nutricionista = nutricionistaEncontrado;
        _planoAlimentar = refeicoesEncontradas;

        if (historico.isNotEmpty) {
          historico.sort(
            (a, b) =>
                (a.data ?? DateTime(2000)).compareTo(b.data ?? DateTime(2000)),
          );
          _ultimaAvaliacao = historico.last;
        }

        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
      setState(() => _isLoading = false);
    }
  }

  Refeicao? get proximaRefeicao {
    if (_paciente == null || _paciente!.refeicoes.isEmpty) return null;

    return _paciente!.refeicoes.first;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.laranja,
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
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : CustomScrollView(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _buildHeader(),
                          const SizedBox(height: 20),
                          if (_paciente?.nutricionistaCrn == null ||
                              _paciente!.nutricionistaCrn!.isEmpty) ...[
                            const SizedBox(height: 20),
                            _buildBuscaNutricionistaSection(),
                          ] else ...[
                            const SizedBox(height: 20),
                            _buildNutricionistaCard(),
                          ],
                          _buildProximaRefeicao(),
                          const SizedBox(height: 25),
                          _buildAvaliacaoFisica(),
                          const SizedBox(height: 100),
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
                text: _paciente?.nome ?? "Nome Sobrenome",
                style: const TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        Text("Idade: ${_paciente?.idade ?? '--'} anos"),
        Text("Peso: ${_ultimaAvaliacao?.massaCorporal ?? '--'} kg"),
        const Text("Objetivo: XX"),
      ],
    );
  }

  Widget _buildBuscaNutricionistaSection() {
    return Column(
      children: [
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 16),
        const Text(
          "Você ainda não possui um nutricionista!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.orange, size: 20),
            label: const Text(
              "Buscar um nutricionista",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange, width: 1),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutricionistaCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(radius: 25),
            title: const Text(
              "Nome Nutricionista",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Última avaliação em ${_ultimaAvaliacao?.data.toString().substring(0, 10) ?? '--'}",
            ),
            trailing: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildProximaRefeicao() {
    if (_planoAlimentar.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Nenhuma refeição cadastrada.',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );
    }
    final proxima = _planoAlimentar.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Divider(color: Colors.black12, thickness: 1),
          const Text(
            'Próxima Refeição',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proxima.nome,
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              proxima.alimentos.map((alimento) {
                                return _buildItemLinha(
                                  "${alimento.nome} (${alimento.quantidade}${alimento.unidade})",
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // marcar como concluida
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("Concluir refeição"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              widget.onMudarAba(2);
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.restaurant_menu, size: 16, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    "Ver o Plano Alimentar Completo",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemLinha(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(" • ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvaliacaoFisica() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 16),
          const Text(
            'Avaliação Física',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF916DD5),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: const Icon(
                        Icons.shape_line,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Última Avaliação',
                        style: TextStyle(
                          color: Color(0xFF916DD5),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${_ultimaAvaliacao?.data?.toString().substring(0, 10) ?? '--'}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      _buildTagAvaliacao(
                        label:
                            "Percentual Gordura: ${_ultimaAvaliacao?.classPercentualGordura}%",
                        color: const Color(0xFFFF9800),
                      ),
                      const SizedBox(height: 6),
                      _buildTagAvaliacao(
                        label:
                            "Massa Gorda: ${_ultimaAvaliacao?.massaGordura}%",
                        color: const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              widget.onMudarAba(1);
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.accessibility_new,
                    size: 16,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Ver Avaliação Completa",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagAvaliacao({required String label, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}