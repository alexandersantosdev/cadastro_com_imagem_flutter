import 'package:flutter/material.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/todo_model.dart';
import 'package:cadastro_hive/repositories/todo_repository.dart';
import 'package:cadastro_hive/shared/text_field.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoRepository todoRepository;
  TextEditingController descriptionController = TextEditingController();
  dynamic todos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    todoRepository = await TodoRepository.load();
    setState(() => todos = todoRepository.getTodos());
  }

  getTodosTile() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key(index.toString()),
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Todo?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  isLoading = true;
                                  todoRepository.delete(index);
                                  setState(
                                      () => todos = todoRepository.getTodos());
                                  Navigator.pop(context);
                                  isLoading = false;
                                })
                          ],
                        );
                      });
                },
                child: ListTile(
                  title: Text(todos[index].description),
                  trailing: Checkbox(
                    onChanged: (value) {
                      setState(() {
                        todos[index].done = value!;
                      });
                    },
                    value: todos[index].done,
                  ),
                ),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tarefas")),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppContants.horizontalPadding),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          getTextField(
              descriptionController, "Descrição", false, null, null, null),
         
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size(double.infinity, 60),
              ),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 20,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              isLoading = true;
              TodoModel model = TodoModel(descriptionController.text, false);
              todoRepository.save(model);
              descriptionController.text = "";
              setState(() => todos = todoRepository.getTodos());
              isLoading = false;
            },
            child: const Text("Salvar"),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: getTodosTile()),
        ]),
      ),
    );
  }
}
