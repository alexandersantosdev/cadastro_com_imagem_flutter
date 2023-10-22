// ignore_for_file: unnecessary_getters_setters

class ConfigurationModel {
  String _name = "";
  String _email = "";
  String _password = "";

  ConfigurationModel(
    this._name,
    this._email,
    this._password,
  );

  ConfigurationModel.vazio() {
    _name = "";
    _email = "";
    _password = "";
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  String get email => _email;
  set email(String value) {
    _email = value;
  }

  String get password => _password;
  set password(String value) {
    _password = value;
  }
}
