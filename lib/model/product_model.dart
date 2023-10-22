import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  String sku = "";

  @HiveField(3)
  int stock = 0;

  @HiveField(4)
  double price = 0.0;

  @HiveField(5)
  String brand = "";

  ProductModel(
    this.name,
    this.sku,
    this.stock,
    this.price,
    this.brand,
  );

  ProductModel.vazio() {
    name = "";
    sku = "";
    stock = 0;
    price = 0.0;
    brand = "";
  }
}
