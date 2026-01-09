import 'package:flutter/material.dart';
import '../../widgets/app_colors.dart';
import 'nutricionista_home_screen.dart';
import './nutricionista_listapacientes_screen.dart';

class NutricionistaNavigation extends StatefulWidget {
  const NutricionistaNavigation({super.key});

  @override
  State<NutricionistaNavigation> createState() =>
      _NutricionistaNavigationState();
}

class _NutricionistaNavigationState extends State<NutricionistaNavigation> {
  int currentPageIndex = 0;

  // Lista das telas separadas
  final List<Widget> _screens = const [
    HomeTabScreen(nutriId: 1), // Index 0
    NutricionistaListaPacientesScreen(), // Index 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        }, 
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
            label: 'Pacientes',
          ),
        ],
      ),

      body: _screens[currentPageIndex],
    );
  }
}
