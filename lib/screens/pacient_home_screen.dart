import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './antropometria_visualizacao_page.dart';
import './app_colors.dart';
import 'plano_alimentar_screen.dart'; 

class PacientHomeScreen extends StatefulWidget {
  const PacientHomeScreen({super.key});

  @override
  State<PacientHomeScreen> createState() => _PacientHomeScreenState();
}

class _PacientHomeScreenState extends State<PacientHomeScreen> {
  int currentPageIndex = 0;

  // Lista das telas separadas
  final List<Widget> _screens = const [
    HomeTabScreen(),       // Index 0
    AntropometriaVisualizacaoPage(pacienteId: 1), // Index 1
    PlanoAlimentarScreen() // Index 2
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

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            'Home page', 
            style: theme.textTheme.titleLarge
          ),
        ),
      ),
    );
  }
}