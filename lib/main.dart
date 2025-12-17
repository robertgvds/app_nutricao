import 'package:flutter/material.dart';
import 'database/testeDB/teste_db.dart'; // Importe a nova tela de teste
import 'telas/cadastro.dart'; // Importe a tela de login
void main() {
  runApp(const MyApp());
}

// ----------------------------------------------------
// 1. Tela de Login (Usuário)
// ----------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela Principal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bem-vindo ao App!", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),

            // Botão que fará o redirecionamento
            ElevatedButton(
              onPressed: () {
                // MÉTODO DE REDIRECIONAMENTO DE TELA
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TesteDb()),
                );
              },
              child: const Text("Ir para Tela de Teste de BD"),
            ),
          
           const SizedBox(height: 30),

            // Botão que fará o redirecionamento
            ElevatedButton(
              onPressed: () {
                // MÉTODO DE REDIRECIONAMENTO DE TELA
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaCadastro()),
                );
              },
              child: const Text("Tela de Login"),
            ),
          
          ],  
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. Widget Raiz (MyApp)
// ----------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define a tela principal como HomePage
      home: HomePage(),
    );
  }
}
