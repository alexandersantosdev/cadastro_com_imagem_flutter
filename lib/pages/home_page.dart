import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/repositories/configuration_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box storage;
  late ConfigurationRepository configurationRepository;

  int number = 0;
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  void loadData() async {
    configurationRepository = await ConfigurationRepository.load();
    var configs = configurationRepository.getConfiguration();

    name = configs.name;
    email = configs.email;

    if (!Hive.isBoxOpen("box_random_numbers")) {
      storage = await Hive.openBox("box_random_numbers");
    } else {
      storage = Hive.box("box_random_numbers");
    }
    setState(() {
      number = storage.get("random_number") ?? 0;
    });
  }

  goToPage(String page, context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AppContants.pages[page]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastros gerais'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
            ),
            TextButton(
              onPressed: () => goToPage("home", context),
              child: const ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
              ),
            ),
            TextButton(
              onPressed: () => goToPage("product", context),
              child: const ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text("Novo Produto"),
              ),
            ),
            TextButton(
              onPressed: () => goToPage("todos", context),
              child: const ListTile(
                leading: Icon(Icons.today),
                title: Text("Tarefas"),
              ),
            ),
            TextButton(
              onPressed: () => goToPage("config", context),
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text("Configurações"),
              ),
            ),
            TextButton(
              onPressed: () => goToPage("people", context),
              child: const ListTile(
                leading: Icon(Icons.people),
                title: Text("Pessoas"),
              ),
            ),
          ],
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Number: $number"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  number = Random().nextInt(100);
                });
                storage.put("random_number", number);
              },
              child: const Text("Add"),
            ),
          ]),
    );
  }
}
