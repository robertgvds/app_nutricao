
import 'package:flutter/material.dart';
import '../../widgets/app_colors.dart';
import 'paciente_antropometria_screen.dart';
import 'paciente_home_screen.dart';
import 'paciente_planoalimentar_screen.dart';

class PacienteNavigation extends StatefulWidget {
  int currentPageIndex = 0;
  PacienteNavigation({super.key, this.currentPageIndex = 0});

  @override
  State<PacienteNavigation> createState() => _PacienteNavigationState();
}

class _PacienteNavigationState extends State<PacienteNavigation> {
  // Lista das telas separadas
  final List<Widget> _screens = const [
    HomeTabScreen(pacienteId: 1), // Index 0
    AntropometriaVisualizacaoPage(pacienteId: 1), // Index 1
    PacientePlanoAlimentarScreen(), // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.currentPageIndex = index;
          });
        }, // Certifique-se de importar AppColors
        selectedIndex: widget.currentPageIndex,
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
      body: _screens[widget.currentPageIndex],
    );
  }
}