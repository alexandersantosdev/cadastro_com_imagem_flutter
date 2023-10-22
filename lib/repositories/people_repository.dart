import 'package:hive/hive.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/person_model.dart';

class PeopleRepository {
  static late Box _box;

  static Future<PeopleRepository> load() async {
    if (Hive.isBoxOpen(AppContants.peopleRepositoryKey)) {
      _box = Hive.box(AppContants.peopleRepositoryKey);
    } else {
      _box = await Hive.openBox(AppContants.peopleRepositoryKey);
    }
    return PeopleRepository._load();
  }

  PeopleRepository._load();

  void save(PersonModel model) {
    _box.add(model);
  }

  dynamic getPeople() {
    var personModel = _box.values.cast<PersonModel>().toList();
    return personModel;
  }

  void delete(int id) {
    _box.deleteAt(id);
  }
}
