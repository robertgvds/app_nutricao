import 'package:app/database/testeDB/teste_db.dart';
import 'package:app/screens/antropometria_edicao_page.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './antropometria_visualizacao_page.dart';
import './app_colors.dart';
import 'plano_alimentar_screen.dart'; 

class NutriHomeScreen extends StatefulWidget {
  const NutriHomeScreen({super.key});

  @override
  State<NutriHomeScreen> createState() => _NutriHomeScreenState();
}

class _NutriHomeScreenState extends State<NutriHomeScreen> {
  int currentPageIndex = 0;

  // Lista das telas separadas
  final List<Widget> _screens = const [
    HomeTabScreen(),       // Index 0
    // LISTA DE PACIENTES // Index 1
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
            selectedIcon: Icon(Icons.accessibility_new_rounded, color: AppColors.roxo),
            icon: Icon(Icons.accessibility_new_outlined),
            label: 'Pacientes',
          ),
        ],
      ),
      // Aqui o body muda dinamicamente com base na lista criada acima
      body: _screens[currentPageIndex],
    );
  }
}

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  // ID fixo apenas para testar a tela de antropometria sem login MUDAR DEPOIS
  final int idPacienteTeste = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Principal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView( // Permite rolagem se necessário
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bem-vindo ao App!", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TesteDb()),
                  );
                },
                child: const Text("Ir para Tela de Teste de BD"),
              ),
              const SizedBox(height: 30),
              
              const SizedBox(height: 40),
              const Divider(thickness: 2), // Linha divisória visual
              const Text("Área de Teste: Antropometria", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 20),

              // Botão Nutricionista 
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Teste: Nutricionista (Editar)"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AntropometriaEdicaoPage(
                        pacienteId: idPacienteTeste,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }
}