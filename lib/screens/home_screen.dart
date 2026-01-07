import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

import 'package:app/screens/login_screen.dart';
import '../database/testeDB/teste_db.dart';
import './antropometria_edicao_page.dart';
import './antropometria_visualizacao_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(
              "TELA HOME",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthService>().logout(),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ID fixo apenas para testar a tela de antropometria sem login MUDAR DEPOIS
  final int idPacienteTeste = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela Principal")),
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
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text("Ir para Tela de Login"),
              ),

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

              // Botão Paciente 
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.visibility),
                label: const Text("Teste: Paciente (Ver)"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AntropometriaVisualizacaoPage(
                        pacienteId: idPacienteTeste,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}