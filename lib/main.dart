import 'package:cadastro_hive/model/person_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cadastro_hive/model/product_model.dart';
import 'package:cadastro_hive/model/todo_model.dart';
import 'package:cadastro_hive/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var documentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(PersonModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
