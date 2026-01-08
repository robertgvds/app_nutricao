import 'package:app/services/auth_service.dart';
import 'package:app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacientePlanoAlimentarScreen extends StatefulWidget {
  const PacientePlanoAlimentarScreen({super.key});

  @override
  State<PacientePlanoAlimentarScreen> createState() => _PacientePlanoAlimentarScreenState();
}

class _PacientePlanoAlimentarScreenState extends State<PacientePlanoAlimentarScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verde,
      appBar: AppBar(
        backgroundColor: AppColors.verde,
        elevation: 0,
        title: const Text('Plano Alimentar', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
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
                          backgroundColor: AppColors.verdeEscuro,
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
                        Text(
                          'Seu Plano Alimentar',
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}