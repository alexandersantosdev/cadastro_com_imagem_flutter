import 'package:hive/hive.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/product_model.dart';

class ProductRepository {
  static late Box _box;

  ProductRepository._load();

  static Future<ProductRepository> load() async {
    if (Hive.isBoxOpen(AppContants.productRepositoryKey)) {
      _box = Hive.box(AppContants.productRepositoryKey);
    } else {
      _box = await Hive.openBox(AppContants.productRepositoryKey);
    }
    return ProductRepository._load();
  }

  void save(ProductModel model) {
    _box.put(AppContants.productModelKey, model);
  }

  ProductModel getProduct() {
    var productModel = _box.get(AppContants.productModelKey);
    if (productModel == null) ProductModel.vazio();
    return productModel;
  }
}
