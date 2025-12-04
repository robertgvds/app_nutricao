import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database/usuario_repository.dart';
import 'database/paciente_repository.dart';
import 'database/nutricionista_repository.dart';
import '/classes/usuario.dart';
import '/classes/paciente.dart';
import '/classes/nutricionista.dart';

class TesteDb extends StatelessWidget {
  final repoUsuario = UsuarioRepository();
  final repoPaciente = PacienteRepository();
  final repoNutricionista = NutricionistaRepository();

  Future<void> apagarBanco() async {
    final path = join(await getDatabasesPath(), 'meu_banco.db');
    await deleteDatabase(path);
    print("✅ BANCO APAGADO!");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Teste SQLite")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await repoUsuario.limparTabela();
                  await repoPaciente.limparTabela();
                  await repoNutricionista.limparTabela();
                  print("✅ Todas as tabelas foram limpas!");
                },
                child: const Text("Limpar Tabelas"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    print("\n========== INSERINDO DADOS ==========");

                    await repoUsuario.inserir(
                      Usuario(
                        nome: "Yuri",
                        email: "teste@gmail.com",
                        senha: 'testesenha1',
                        codigo: '12345',
                      ),
                    );
                    print("✅ Usuário inserido");

                    await repoPaciente.inserir(
                      Paciente(
                        nome: "Ana",
                        email: 'teste2@email.com',
                        senha: 'testesenha2',
                        codigo: '54321',
                        refeicoes: ['Café', 'Almoço', 'Jantar'],
                      ),
                    );
                    print("✅ Paciente inserido");

                    await repoNutricionista.inserir(
                      Nutricionista(
                        nome: "Carlos",
                        email: 'carlos@nutri.com',
                        senha: 'testesenha3',
                        codigo: '678901',
                      ),
                    );
                    print("✅ Nutricionista inserido");

                    print("\n========== LISTANDO USUÁRIOS ==========");
                    final usuarios = await repoUsuario.listar();
                    for (var u in usuarios) {
                      print(
                        "ID: ${u.id} | Nome: ${u.nome} | Email: ${u.email} | Código: ${u.codigo}",
                      );
                    }

                    print("\n========== LISTANDO PACIENTES ==========");
                    final pacientes = await repoPaciente.listar();
                    for (var p in pacientes) {
                      print(
                        "ID: ${p.id} | Nome: ${p.nome} | Email: ${p.email} | Refeições: ${p.refeicoes} | Código: ${p.codigo}",
                      );
                    }

                    print("\n========== LISTANDO NUTRICIONISTAS ==========");
                    final nutri = await repoNutricionista.listar();
                    for (var n in nutri) {
                      print(
                        "ID: ${n.id} | Nome: ${n.nome} | Email: ${n.email} | CRN: ${n.crn} | Código: ${n.codigo}",
                      );
                    }

                    print("\n========== TESTE DE BUSCA ==========");
                    final paciente1 = await repoPaciente.buscarPorId(1);
                    if (paciente1 != null) {
                      print("✅ Paciente encontrado: ${paciente1.nome}");
                    }

                    final nutri1 = await repoNutricionista.buscarPorId(1);
                    if (nutri1 != null) {
                      print("✅ Nutricionista encontrado: ${nutri1.nome}");
                    }

                    print("\n========== TODOS OS TESTES CONCLUÍDOS ==========");
                  } catch (e) {
                    print("❌ ERRO: $e");
                  }
                },
                child: const Text("Executar Teste Completo"),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),

              // BOTÃO PARA VOLTAR
              ElevatedButton(
                // 👈 A chave é esta função: Navigator.pop(context)
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar para a Tela Principal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
