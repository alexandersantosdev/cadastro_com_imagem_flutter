import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 3)
class PersonModel extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  String email = "";
  @HiveField(2)
  String image = "";


  PersonModel(this.name, this.email, this.image);
  PersonModel.vazio();
}
