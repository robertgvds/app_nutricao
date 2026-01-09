import 'package:app/database/taco_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_colors.dart';
import '../../classes/refeicao.dart';
import '../../classes/paciente.dart';
import '../../classes/alimento.dart';
import '../../database/paciente_repository.dart';

class PacientePlanoAlimentarScreen extends StatefulWidget {
  const PacientePlanoAlimentarScreen({super.key});

  @override
  State<PacientePlanoAlimentarScreen> createState() =>
      _PacientePlanoAlimentarScreenState();
}

class _PacientePlanoAlimentarScreenState
    extends State<PacientePlanoAlimentarScreen> {
  bool _isLoading = true;
  Paciente? _paciente;
  List<Refeicao> _refeicoesDoDia = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    // Simulação: Carregando dados do usuário logado e buscando na TACO
    // Em produção, use: final user = context.read<AuthService>().usuario;
    // e PacienteRepository().buscarPorId(user.uid);
    
    await Future.delayed(const Duration(seconds: 1)); // Fake loading

    // Mock de Refeições usando os dados da TACO (TacoDB)
    // Estamos pegando alimentos reais da nossa lista "salva"
    final cafeDaManha = Refeicao(
      id: '1',
      nome: 'Café da Manhã',
      horario: '08:00',
      alimentos: [
        TacoDB.list.firstWhere((a) => a.id == '53') // Pão francês
          ..quantidade = 50, // 1 unidade
        TacoDB.list.firstWhere((a) => a.id == '13') // Biscoito Cream Cracker
          ..quantidade = 30,
      ],
    );

    final almoco = Refeicao(
      id: '2',
      nome: 'Almoço',
      horario: '12:30',
      alimentos: [
        TacoDB.list.firstWhere((a) => a.id == '1'), // Arroz integral
        TacoDB.list.firstWhere((a) => a.id == '56'), // Pastel (Dia do lixo?)
        TacoDB.list.firstWhere((a) => a.id == '109'), // Cenoura
      ],
    );

    if (mounted) {
      setState(() {
        _refeicoesDoDia = [cafeDaManha, almoco];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verde,
      appBar: AppBar(
        backgroundColor: AppColors.verde,
        elevation: 0,
        title: const Text(
          'Plano Alimentar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : CustomScrollView(
              slivers: [
                // 2. O botão fica dentro de um SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Exportando PDF...')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf, size: 20),
                        label: const Text('Exportar como PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.verdeEscuro,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. A parte branca usa SliverFillRemaining
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
                        const Text(
                          'Refeições do Dia',
                          style: TextStyle(
                            color: AppColors.verde,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Baseado na Tabela TACO',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 20),

                        // Lista de Refeições
                        if (_refeicoesDoDia.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text("Nenhuma refeição planejada."),
                            ),
                          )
                        else
                          ..._refeicoesDoDia.map((refeicao) => _buildRefeicaoItem(refeicao)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRefeicaoItem(Refeicao refeicao) {
    // Calculando totais da refeição
    double cal = refeicao.alimentos.fold(0, (sum, a) => sum + a.totalCalorias);
    double prot = refeicao.alimentos.fold(0, (sum, a) => sum + a.totalProteinas);
    double carb = refeicao.alimentos.fold(0, (sum, a) => sum + a.totalCarboidratos);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.verde.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: AppColors.verde),
          ),
          title: Text(
            refeicao.nome,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            '${refeicao.horario} • ${cal.toStringAsFixed(0)} kcal',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          children: [
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  // Resumo Macros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroBadge("Carb", "${carb.toStringAsFixed(1)}g", Colors.orange),
                      _buildMacroBadge("Prot", "${prot.toStringAsFixed(1)}g", Colors.blue),
                      _buildMacroBadge("Gord", "${refeicao.alimentos.fold(0.0, (s,a) => s + a.totalGorduras).toStringAsFixed(1)}g", Colors.red),
                    ],
                  ),
                  const Divider(height: 20),
                  // Lista de alimentos
                  ...refeicao.alimentos.map((alimento) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(alimento.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text("${alimento.calorias} kcal / 100g"),
                    trailing: Text(
                      "${alimento.quantidade.toStringAsFixed(0)}g",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.verde),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text("$label: $value", style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}