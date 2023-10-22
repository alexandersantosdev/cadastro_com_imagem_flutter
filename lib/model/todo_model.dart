import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 2)
class TodoModel extends HiveObject {
  @HiveField(0)
  String description = "";
  @HiveField(1)
  bool done = false;

  TodoModel(this.description, this.done);
  TodoModel.vazio();
}
