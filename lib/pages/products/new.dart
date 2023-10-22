import 'package:flutter/material.dart';
import 'package:cadastro_hive/constants.dart';
import 'package:cadastro_hive/model/product_model.dart';
import 'package:cadastro_hive/repositories/product_repository.dart';
import 'package:cadastro_hive/shared/text_field.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductRepository productRepository;

  TextEditingController nameController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  String name = "";
  String sku = "";
  String stock = "";
  String price = "";
  String brand = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    productRepository = await ProductRepository.load();
    var product = productRepository.getProduct();

    name = product.name;
    sku = product.sku;
    stock = product.stock.toString();
    price = product.price.toString();
    brand = product.brand;

    setState(() {
      nameController.text = name;
      skuController.text = sku;
      stockController.text = stock.toString();
      priceController.text = price.toString();
      brandController.text = brand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produto"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppContants.horizontalPadding),
        child: ListView(
          children: [
            getTextField(nameController, 'Nome', false, null, null, null),
            getTextField(skuController, 'Sku', false, null, null, null),
            getTextField(stockController, 'Estoque', false, null, null, null),
            getTextField(priceController, 'Preço', false, null, null, null),
            getTextField(brandController, 'Marca', false, null, null, null),
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
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
              onPressed: () {
                if (name != nameController.text ||
                    sku != skuController.text ||
                    stock != stockController.text ||
                    price != priceController.text ||
                    brand != brandController.text) {
                  productRepository.save(ProductModel(
                      nameController.text,
                      skuController.text,
                      int.parse(stockController.text),
                      double.parse(priceController.text),
                      brandController.text));
                }
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
