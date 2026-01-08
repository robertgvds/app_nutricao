import 'package:app/database/testeDB/teste_db.dart';
import 'package:app/screens/nutricionista/nutricionista_antropometria_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_colors.dart';

class NutricionistaListaPacientesScreen extends StatelessWidget {
  const NutricionistaListaPacientesScreen({super.key});

  // ID fixo apenas para testar a tela de antropometria sem login MUDAR DEPOIS
  final int idPacienteTeste = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pacientes"),
        backgroundColor: AppColors.roxo,
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
              const Text("Aqui será exibida a lista de pacientes do nutricionista.", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TesteDb()),
                  );
                },
                child: const Text("Ir para Teste DB"),
              ),

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
                      builder: (context) => NutricionistaAntropometriaScreen(
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