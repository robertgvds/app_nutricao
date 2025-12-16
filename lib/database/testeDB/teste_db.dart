import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../usuario_repository.dart';
import '../paciente_repository.dart';
import '../nutricionista_repository.dart';
import 'formularios/formularioUsuario.dart';
import 'formularios/formularioNutricionista.dart';
import 'formularios/formularioPaciente.dart';
import 'formularios/formularioAddRefeicao.dart';
import 'formularios/formularioAddAntropometria.dart';
import 'formularios/evoluiUsuario.dart';

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
                    print("\n========== LISTANDO USUÁRIOS ==========");
                    final usuarios = await repoUsuario.listar();
                    for (var u in usuarios) {
                      if (usuarios.isEmpty) {
                        print("Nenhum usuário encontrado.");
                        break;
                      } else {
                        print(
                          "ID: ${u.id} | Nome: ${u.nome} | senha: ${u.senha} | Email: ${u.email} | Código: ${u.codigo}",
                        );
                      }
                    }

                    print("\n========== LISTANDO PACIENTES ==========");
                    final pacientes = await repoPaciente.listar();

                    if (pacientes.isEmpty) {
                      print("Nenhum paciente encontrado.");
                    } else {
                      for (var p in pacientes) {
                        // 1. DADOS BÁSICOS
                        print(
                          "ID: ${p.id} | Nome: ${p.nome} | Email: ${p.email} | Senha: ${p.senha} | Código: ${p.codigo} | CRN Nutri: ${p.nutricionistaCrn}",
                        );

                        // 2. DADOS CORPORAIS (NOVO BLOCO)
                        if (p.antropometria == null) {
                          print("   └── [Sem medidas corporais cadastradas]");
                        } else {
                          final d = p.antropometria!;
                          print("   └── [MEDIDAS CORPORAIS]");
                          print("       • Peso: ${d.massaCorporal ?? '--'} kg");
                          print(
                            "       • Gordura: ${d.massaGordura ?? '--'} kg (${d.percentualGordura ?? '--'}%)",
                          );
                          print(
                            "       • Massa Esq.: ${d.massaEsqueletica ?? '--'} kg",
                          );
                          print("       • IMC: ${d.imc ?? '--'}");
                          print("       • CMB: ${d.cmb ?? '--'} cm");
                          print(
                            "       • RCQ: ${d.relacaoCinturaQuadril ?? '--'}",
                          );
                        }

                        // 3. REFEIÇÕES
                        if (p.refeicoes.isEmpty) {
                          print("   └── [Sem refeições cadastradas]");
                        } else {
                          for (var r in p.refeicoes) {
                            String itens = r.alimentos
                                .map((a) => a.nome)
                                .join(', ');

                            print("   └── REFEIÇÃO: ${r.nome.toUpperCase()}");
                            print(
                              "       • Totais: ${r.caloriasTotal.toStringAsFixed(1)} kcal | ${r.pesoTotal.toStringAsFixed(1)} g",
                            );
                            print("       • Alimentos: [$itens]");
                          }
                        }

                        // LINHA SEPARADORA
                        print(
                          "---------------------------------------------------",
                        );
                      }
                    }

                    print("\n========== LISTANDO NUTRICIONISTAS ==========");
                    final nutri = await repoNutricionista.listar();

                    if (nutri.isEmpty) {
                      print("Nenhum nutricionista encontrado.");
                    } else {
                      for (var n in nutri) {
                        print(
                          "ID: ${n.id} | "
                          "Nome: ${n.nome} | "
                          "Email: ${n.email} | "
                          "CRN: ${n.crn} | "
                          "Código: ${n.codigo} | "
                          "Pacientes (IDs): ${n.pacientesIds} | " // Mostra a lista [1, 2, 3]
                          "Total: ${n.pacientesIds.length} paciente(s)", // Mostra a contagem
                        );
                      }
                    }
                  } catch (e) {
                    print("❌ ERRO: $e");
                  }
                },
                child: const Text("Mostrar Dados no Console"),
              ),

              const SizedBox(height: 20),

              // Adicione este botão dentro da Column do seu build
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroUsuarioPage(),
                    ),
                  );
                },
                child: const Text("Ir para Formulário de Usuário"),
              ),

              const SizedBox(height: 20),

              // Adicione este botão dentro da Column do seu build
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroNutricionistaPage(),
                    ),
                  );
                },
                child: const Text("Ir para Formulário de Nutricionista"),
              ),

              const SizedBox(height: 20),

              // Adicione este botão dentro da Column do seu build
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroPacientePage(),
                    ),
                  );
                },
                child: const Text("Ir para Formulário de Paciente"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdicionarRefeicaoPage(),
                    ),
                  );
                },
                child: const Text("adicionar Refeição a um paciente"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdicionarMedidasPage(),
                    ),
                  );
                },
                child: const Text("adicionar antropometria a um paciente"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvolucaoUsuarioPage(),
                    ),
                  );
                },
                child: const Text(
                  "evolui usuario para paciente ou nutricionista",
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            // Usamos SizedBox para forçar a largura total
            width: double.infinity,
            child: ElevatedButton.icon(
              // Usamos ElevatedButton.icon para adicionar um ícone
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back), // Ícone de destaque
              label: const Text("VOLTAR PARA O MENU PRINCIPAL"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ), // Aumenta a altura
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
