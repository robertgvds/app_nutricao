
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

  Color _getBackgroundColor(int index) {
    return switch (index) {
      0 => AppColors.laranja,
      1 => AppColors.roxo,
      2 => AppColors.verde,
      _ => Colors.white,
    };
  }

  Color _getForegroundColor(int index) {
    return switch (index) {
      0 => AppColors.laranjaClaro,
      1 => AppColors.roxoClaro,
      2 => AppColors.verdeClaro,
      _ => Colors.black,
    };
  }

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
        backgroundColor: Colors.white,
        indicatorColor: _getForegroundColor(widget.currentPageIndex),
        surfaceTintColor: _getForegroundColor(widget.currentPageIndex),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.accessibility_new_rounded,
            ),
            icon: Icon(Icons.accessibility_new_outlined),
            label: 'Antropometria',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant_menu),
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