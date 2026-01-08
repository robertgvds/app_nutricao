import 'package:app/services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../classes/antropometria.dart';
import '../../database/antropometria_repository.dart';
import '../../widgets/app_colors.dart';

class AntropometriaVisualizacaoPage extends StatefulWidget {
  final int pacienteId;

  const AntropometriaVisualizacaoPage({Key? key, required this.pacienteId})
      : super(key: key);

  @override
  State<AntropometriaVisualizacaoPage> createState() =>
      _AntropometriaVisualizacaoPageState();
}

class _AntropometriaVisualizacaoPageState
    extends State<AntropometriaVisualizacaoPage> {
  final _repository = AntropometriaRepository();

  Antropometria? _ultimaAvaliacao;
  List<Antropometria> _historico = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final historico = await _repository.buscarHistorico(widget.pacienteId);

    if (historico.isNotEmpty) {
      historico.sort((a, b) =>
          (a.data ?? DateTime(2000)).compareTo(b.data ?? DateTime(2000)));

      _ultimaAvaliacao = historico.last;
    } else {
      _ultimaAvaliacao = null;
    }

    setState(() {
      _historico = historico;
      _isLoading = false;
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.roxo,
      appBar: AppBar(
        backgroundColor: AppColors.roxo,
        elevation: 0,
        title: const Text('Antropometria', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      // 1. Alterado para CustomScrollView
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
                              const SnackBar(content: Text('Exportando PDF...')));
                        },
                        icon: const Icon(Icons.picture_as_pdf, size: 20),
                        label: const Text('Exportar como PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B52AB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. A parte branca usa SliverFillRemaining para ocupar todo o espaço restante
                SliverFillRemaining(
                  hasScrollBody: false, // Importante: Permite que o container estique ou role conforme necessário
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
                        horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Última Avaliação Física',
                            style: TextStyle(
                                color: AppColors.roxo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildCardResumo(),

                        const SizedBox(height: 24),

                        Text('Análise de Índices Corporais',
                            style: TextStyle(
                                color: AppColors.roxo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text('Legenda: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            _buildLegendaChip('Abaixo', const Color(0xFF5E6EE6)),
                            _buildLegendaChip('Ideal', const Color(0xFF4CAF50)),
                            _buildLegendaChip('Acima', const Color(0xFFFF7043)),
                            const Spacer(),
                            const Text('+ Saiba mais',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (_ultimaAvaliacao != null) ...[
                          _buildIndicadorBarra(
                              'Massa Corporal Total',
                              _ultimaAvaliacao!.massaCorporal,
                              'kg',
                              _ultimaAvaliacao!.classMassaCorporal),
                          _buildIndicadorBarra(
                              'Massa de Gordura',
                              _ultimaAvaliacao!.massaGordura,
                              'kg',
                              _ultimaAvaliacao!.classMassaGordura),
                          _buildIndicadorBarra(
                              'Percentual de Gordura',
                              _ultimaAvaliacao!.percentualGordura,
                              '%',
                              _ultimaAvaliacao!.classPercentualGordura),
                          _buildIndicadorBarra(
                              'Massa Esquelética',
                              _ultimaAvaliacao!.massaEsqueletica,
                              'kg',
                              _ultimaAvaliacao!.classMassaEsqueletica),
                          _buildIndicadorBarra(
                              'IMC (Índice de Massa)',
                              _ultimaAvaliacao!.imc,
                              '',
                              _ultimaAvaliacao!.classImc),
                          _buildIndicadorBarra(
                              'CMB (Circunferência)',
                              _ultimaAvaliacao!.cmb,
                              '',
                              _ultimaAvaliacao!.classCmb),
                          _buildIndicadorBarra(
                              'Relação Cintura/Quadril',
                              _ultimaAvaliacao!.relacaoCinturaQuadril,
                              '',
                              _ultimaAvaliacao!.classRcq),
                        ] else
                          const Text("Nenhuma avaliação cadastrada.",
                              style: TextStyle(color: Colors.grey)),

                        const SizedBox(height: 30),

                        Text('Histórico de avaliações',
                            style: TextStyle(
                                color: AppColors.roxo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        if (_historico.length < 2)
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.show_chart, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  "Cadastre pelo menos 2 avaliações para visualizar a evolução nos gráficos.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          _buildGraficoCard(
                            titulo: "Evolução do Peso (kg)",
                            dados: _historico,
                            getValor: (a) => a.massaCorporal ?? 0,
                            corLinha: AppColors.roxo,
                            unidade: 'kg',
                          ),
                          _buildGraficoCard(
                            titulo: "Massa Muscular Esquelética (kg)",
                            dados: _historico,
                            getValor: (a) => a.massaEsqueletica ?? 0,
                            corLinha: const Color(0xFF4CAF50),
                            unidade: 'kg',
                          ),
                          _buildGraficoCard(
                            titulo: "Percentual de Gordura (%)",
                            dados: _historico,
                            getValor: (a) => a.percentualGordura ?? 0,
                            corLinha: const Color(0xFFFF7043),
                            unidade: '%',
                          ),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCardResumo() {
    if (_ultimaAvaliacao == null) return const SizedBox();

    double gordura = _ultimaAvaliacao!.percentualGordura ?? 0;
    double magra = 100 - gordura;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.category, color: Colors.white, size: 30)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Avaliação Física",
                    style: TextStyle(
                        color: AppColors.roxo,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                    DateFormat('dd/MM/yyyy')
                        .format(_ultimaAvaliacao!.data ?? DateTime.now()),
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(children: [
                  _buildBadge('Massa Magra: ${magra.toStringAsFixed(0)}%',
                      Colors.orange),
                  const SizedBox(width: 8),
                  _buildBadge('Massa Gorda: ${gordura.toStringAsFixed(0)}%',
                      Colors.green)
                ]),
                const SizedBox(height: 12),
                Text(_ultimaAvaliacao!.observacoes ?? '',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIndicadorBarra(
      String label, double? valor, String unidade, String? classificacao) {

    Color cor;
    if (classificacao == 'Abaixo') {
      cor = const Color(0xFF5E6EE6); 
    } else if (classificacao == 'Acima') {
      cor = const Color(0xFFFF7043); 
    } else {
      cor = const Color(0xFF4CAF50); 
    }

    double v = valor ?? 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: 0.6, 
                      minHeight: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(cor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${v.toStringAsFixed(0)}$unidade',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: cor, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCard({
    required String titulo,
    required List<Antropometria> dados,
    required double Function(Antropometria) getValor,
    required Color corLinha,
    required String unidade,
  }) {
    List<FlSpot> spots = [];
    double maxY = 0;
    double minY = 9999;

    for (int i = 0; i < dados.length; i++) {
      final val = getValor(dados[i]);
      if (val > maxY) maxY = val;
      if (val < minY) minY = val;
      spots.add(FlSpot(i.toDouble(), val));
    }

    if (maxY == 0) maxY = 100;
    double intervalY = (maxY - minY) / 4;
    if (intervalY <= 0) intervalY = 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          const Text("Evolução temporal",
              style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 12),
          Container(
            height: 220,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            padding:
                const EdgeInsets.only(right: 24, left: 12, top: 24, bottom: 12),
            child: LineChart(
              LineChartData(
                minY: (minY - intervalY).clamp(0, 9999),
                maxY: maxY + intervalY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: intervalY,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.min || value == meta.max) {
                          return const SizedBox();
                        }
                        return Text(
                          value.toStringAsFixed(0),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < dados.length) {
                          final data = dados[index].data ?? DateTime.now();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd/MM').format(data),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    left: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: corLinha,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                        show: true, color: corLinha.withOpacity(0.1)),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toStringAsFixed(1)} $unidade',
                          TextStyle(
                              color: corLinha, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLegendaChip(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}