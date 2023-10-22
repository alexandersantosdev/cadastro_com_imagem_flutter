import 'package:hive/hive.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/configuration_model.dart';

class ConfigurationRepository {
  static late Box _box;
  ConfigurationRepository._load();

  static Future<ConfigurationRepository> load() async {
    if (Hive.isBoxOpen(AppContants.configRepositoryKey)) {
      _box = Hive.box(AppContants.configRepositoryKey);
    } else {
      _box = await Hive.openBox(AppContants.configRepositoryKey);
    }
    return ConfigurationRepository._load();
  }

  void save(ConfigurationModel model) {
    _box.put(AppContants.configModelKey,
        {"name": model.name, "email": model.email, "password": model.password});
  }

  ConfigurationModel getConfiguration() {
    var configurationModel = _box.get(AppContants.configModelKey);

    if (configurationModel == null) {
      return ConfigurationModel.vazio();
    }

    return ConfigurationModel(
      configurationModel["name"],
      configurationModel["email"],
      configurationModel["password"],
    );
  }
}
