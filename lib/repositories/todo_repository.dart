import 'package:hive/hive.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/todo_model.dart';

class TodoRepository {
  static late Box _box;

  static Future<TodoRepository> load() async {
    if (Hive.isBoxOpen(AppContants.todoRepositoryKey)) {
      _box = Hive.box(AppContants.todoRepositoryKey);
    } else {
      _box = await Hive.openBox(AppContants.todoRepositoryKey);
    }
    return TodoRepository._load();
  }

  TodoRepository._load();

  void save(TodoModel model) {
    _box.add(model);
  }

  dynamic getTodos() {
    var todoModel = _box.values.cast<TodoModel>().toList();
    return todoModel;
  }

  void delete(int id) {
    _box.deleteAt(id);
  }
}
