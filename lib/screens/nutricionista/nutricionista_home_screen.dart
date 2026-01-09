import 'package:flutter/material.dart';
import 'package:app/database/testeDB/teste_db.dart';
import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../classes/refeicao.dart';
import '../../classes/nutricionista.dart';
import '../../database/nutricionista_repository.dart';
import '../../database/paciente_repository.dart';
import '../../classes/paciente.dart';
import '../../database/antropometria_repository.dart';
import 'nutricionista_antropometria_screen.dart';

class HomeTabScreen extends StatefulWidget {
  final int nutriId;
  const HomeTabScreen({super.key, required this.nutriId});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
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

      setState(() {
        _nutricionista = nutri;

        if (_nutricionista != null) {
          _meusPacientes =
              todosPacientes
                  .where((p) => _nutricionista!.pacientesIds.contains(p.id))
                  .toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar banco: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _adicionarPaciente(int pacienteId) async {
    if (_nutricionista == null) return;

    setState(() {
      _nutricionista!.adicionarPaciente(pacienteId);
    });

    await _nutriRepo.atualizar(_nutricionista!);
    await _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
              ..._meusPacientes.where((p) => p.antropometria == null).map((p) {
                return _cardAvaliacaoPendente(p);
              }).toList(),

              const SizedBox(height: 50),
            ],
          ),
        ),
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
                text: _nutricionista?.nome ?? "",
                style: const TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        Text("Pacientes ativos: ${_nutricionista?.pacientesIds.length ?? 0}"),
        Text(
          "CRN: ${_nutricionista?.crn ?? ""}",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  /* Widget _itemNovoPaciente(Paciente paciente) { //comentei pq o nutri digita o id do paciente direto
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            paciente.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("ID: ${paciente.id} | Idade: ${paciente.idade} anos"),
        ),
        Row(
          children: [
            Expanded(
              child: _btnAcao(
                "Recusar",
                Colors.grey[300]!,
                Colors.black54,
                () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _btnAcao(
                "Adicionar",
                Colors.green,
                Colors.white,
                () => _adicionarPaciente(paciente.id!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  } */

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
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          if (antro != null) ...[
            _buildMiniTag(
              "Massa de Gordura: ${antro.massaGordura}%",
              Colors.orange,
            ),
            _buildMiniTag(
              "Massa Total: ${antro.massaCorporal} kg",
              Colors.green,
            ),
          ],
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAF87EF),
              foregroundColor: Colors.white,
            ),
            label: const Text("Adicionar Avaliação"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NutricionistaAntropometriaScreen(
                        pacienteId: paciente.id!,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8),
        child: CircleAvatar(backgroundColor: Colors.orange),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSecaoTitulo(String t, Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Text(
      t,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c),
    ),
  );

  /* Widget _btnAcao(String l, Color bg, Color tx, VoidCallback fn) =>
      ElevatedButton(
        onPressed: fn,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: tx,
          elevation: 0,
        ),
        child: Text(l),
      ); */

  Widget _buildMiniTag(String t, Color c) => Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 10)),
  );
}
