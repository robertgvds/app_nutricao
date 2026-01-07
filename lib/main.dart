// arquivo: main.dart
import 'dart:io';
import 'package:app/telas/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import 'database/testeDB/teste_db.dart';
import 'telas/antropometria_edicao_page.dart';
import 'telas/antropometria_visualizacao_page.dart';

import 'services/auth_service.dart';
import 'widgets/auth_check.dart';

void main() async {
  // 1. Garante que o Flutter carregue os plugins antes de iniciar
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ATIVA O CACHE LOCAL (Torna o app instantâneo)
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  // 2. Inicializa o driver para Windows/Linux/macOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Removi o const aqui para permitir alterar theme se quiser
      debugShowCheckedModeBanner: false,
      title: 'App Nutrição',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Adicionei um tema básico roxo
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}