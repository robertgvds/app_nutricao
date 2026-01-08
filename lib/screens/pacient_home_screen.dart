import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './antropometria_visualizacao_page.dart';
import './app_colors.dart';
import 'plano_alimentar_screen.dart';
import '../classes/antropometria.dart';
import '../database/antropometria_repository.dart';
import '../database/paciente_repository.dart';
import '../classes/paciente.dart';
import '../classes/refeicao.dart';

class PacientHomeScreen extends StatefulWidget {
  const PacientHomeScreen({super.key});

  @override
  State<PacientHomeScreen> createState() => _PacientHomeScreenState();
}

class _PacientHomeScreenState extends State<PacientHomeScreen> {
  int currentPageIndex = 0;

  // Lista das telas separadas
  final List<Widget> _screens = const [
    HomeTabScreen(pacienteId: 1), // Index 0
    AntropometriaVisualizacaoPage(pacienteId: 1), // Index 1
    PlanoAlimentarScreen(), // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        }, // Certifique-se de importar AppColors
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: AppColors.laranja),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.accessibility_new_rounded,
              color: AppColors.roxo,
            ),
            icon: Icon(Icons.accessibility_new_outlined),
            label: 'Antropometria',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant_menu, color: AppColors.verde),
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Plano Alimentar',
          ),
        ],
      ),
      // Aqui o body muda dinamicamente com base na lista criada acima
      body: _screens[currentPageIndex],
    );
  }
}

class HomeTabScreen extends StatefulWidget {
  final int pacienteId;
  const HomeTabScreen({super.key, required this.pacienteId});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final _antropometriaRepo = AntropometriaRepository();
  final _pacienteRepo = PacienteRepository();
  Antropometria? _ultimaAvaliacao;
  Paciente? _paciente;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosHome();
  }

  Future<void> _carregarDadosHome() async {
    try {
      final resultados = await Future.wait([
        _antropometriaRepo.buscarHistorico(widget.pacienteId),
        _pacienteRepo.buscarPorId(widget.pacienteId),
      ]);

      final historico = resultados[0] as List<Antropometria>;
      final pacienteEncontrado = resultados[1] as Paciente?;

      setState(() {
        _paciente = pacienteEncontrado;

        if (historico.isNotEmpty) {
          historico.sort(
            (a, b) =>
                (a.data ?? DateTime(2000)).compareTo(b.data ?? DateTime(2000)),
          );
          _ultimaAvaliacao = historico.last;
        }

        _isLoading = false; // Só encerra o loading aqui
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: NetworkImage('url_da_foto')),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            if (_paciente?.nutricionistaCrn == null ||
                _paciente!.nutricionistaCrn!.isEmpty) ...[
              const SizedBox(height: 20),
              _buildBuscaNutricionistaSection(),
              /* ] else ...[ */
              const SizedBox(height: 20),
              _buildNutricionistaCard(),
            ],
            _buildProximaRefeicao(),
            SizedBox(height: 25),
            _buildAvaliacaoFisica(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Componente de Cabeçalho
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: "Olá, "),
              TextSpan(
                text: _paciente?.nome ?? "Nome Sobrenome",
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        Text("Idade: ${_paciente?.idade ?? '--'} anos"),
        Text("Peso: ${_ultimaAvaliacao?.massaCorporal ?? '--'} kg"),
        Text("Objetivo: XX"),
      ],
    );
  }

  Widget _buildBuscaNutricionistaSection() {
    return Column(
      children: [
        // Linha divisória superior
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 16),

        // Texto informativo
        const Text(
          "Você ainda não possui um nutricionista!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Botão de Busca
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Lógica para navegar para tela de busca
            },
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
              shape: const StadiumBorder(), // Formato arredondado
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Card do Nutricionista
  Widget _buildNutricionistaCard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(radius: 25),
            title: Text(
              "Nome Nutricionista",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Última avaliação em ${_ultimaAvaliacao?.data ?? '--'}",
            ),
            trailing: Icon(Icons.add_circle_outline),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today),
                  label: Text("Agenda"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProximaRefeicao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Linha divisória inferior
          const Divider(color: Colors.black12, thickness: 1),
          // Cabeçalho da Seção
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Próxima Refeição',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  "00:00",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ), */
              /* const SizedBox(width: 12), */
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0), // Cinza claro do fundo
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nome da Refeição",
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Box Branco com os itens
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemLinha("TextTextTextText"),
                            _buildItemLinha("TextTextTextText"),
                            _buildItemLinha("TextTextTextText"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botão Analisar outras opções
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swap_horiz, size: 18),
                          label: const Text("Analisar outras opções"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB2FFB4),
                            foregroundColor: const Color(0xFF2E7D32),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Botão Concluir refeição
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
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

          // Botão Inferior "Ver Plano Alimentar"
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlanoAlimentarScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(
              25,
            ), // Mantém o efeito visual dentro do raio
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
          // Título da Seção
          const Text(
            'Avaliação Física',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF916DD5), // Roxo da imagem
            ),
          ),
          const SizedBox(height: 12),

          // Card Principal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0), // Cinza claro de fundo
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
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://via.placeholder.com/100',
                          ),
                          opacity: 0.3,
                        ),
                      ),
                      child: const Icon(
                        Icons.shape_line,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Conteúdo da Direita
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
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 10),

                      _buildTagAvaliacao(
                        label:
                            "Percentual Gordura: ${_ultimaAvaliacao?.classPercentualGordura}%",
                        color: const Color(0xFFFF9800), // Laranja
                      ),
                      const SizedBox(height: 6),

                      _buildTagAvaliacao(
                        label:
                            "Massa Gorda: ${_ultimaAvaliacao?.massaGordura}%",
                        color: const Color(0xFF4CAF50), // Verde
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Botão Inferior "Ver Avaliação Completa"
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AntropometriaVisualizacaoPage(
                        pacienteId: widget.pacienteId,
                      ),
                ),
              );
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

  // Widget auxiliar para as tags coloridas (Massa Magra/Gorda)
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
