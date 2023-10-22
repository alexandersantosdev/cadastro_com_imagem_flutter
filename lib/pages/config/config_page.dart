import 'package:flutter/material.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/configuration_model.dart';
import 'package:cadastro_hive/repositories/configuration_repository.dart';
import 'package:cadastro_hive/shared/text_field.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late ConfigurationRepository configurationRepository;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String name = "";
  String email = "";
  String password = "";

  bool notVisiblePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    loadData();
  }

  void loadData() async {
    configurationRepository = await ConfigurationRepository.load();
    var configs = configurationRepository.getConfiguration();

    name = configs.name;
    email = configs.email;
    password = configs.password;

    setState(() {
      nameController.text = name;
      emailController.text = email;
      passwordController.text = password;
    });

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppContants.horizontalPadding),
        child: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Center(child: CircularProgressIndicator())],
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Dados do usuário",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  getTextField(
                      nameController, 'Nome', false, Icons.person, null, null),
                  getTextField(
                      emailController, 'Email', false, Icons.mail, null, null),
                  getTextField(passwordController, 'Senha', notVisiblePassword,
                      Icons.key, null, () {
                    setState(() {
                      notVisiblePassword = !notVisiblePassword;
                    });
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(double.infinity, 60),
                        ),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 20,
                        )),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    onPressed: () {
                      if (name != nameController.text ||
                          email != emailController.text ||
                          password != passwordController.text) {
                        configurationRepository.save(ConfigurationModel(
                            nameController.text,
                            emailController.text,
                            passwordController.text));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Salvar"),
                  )
                ],
              ),
      ),
    );
  }
}
