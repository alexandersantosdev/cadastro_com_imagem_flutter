import 'package:flutter/material.dart';
import 'package:cadastro_hive/pages/config/config_page.dart';
import 'package:cadastro_hive/pages/home_page.dart';
import 'package:cadastro_hive/pages/people/people_page.dart';
import 'package:cadastro_hive/pages/products/new.dart';
import 'package:cadastro_hive/pages/todo_page.dart';

class AppContants {

  static double horizontalPadding = 25.0;
  static String productRepositoryKey = "products";
  static String productModelKey = "productsModel";
  static String configRepositoryKey = "configuration";
  static String configModelKey = "configurationModel";
  static String todoRepositoryKey = "todos";
  static String peopleRepositoryKey = "people";
  
  static const Map<String, Widget> pages = {
    "home": HomePage(),
    "config": ConfigPage(),
    "product": NewProductPage(),
    "todos": TodoPage(),
    "people": PeoplePage(),
  };
}
