import 'package:fryo/src/helper_database.dart';

class ProductModel {
  int id;
  String name;
  String image;
  String duscription;
  String categoryName;
  double price;

  ProductModel(this.id, this.name, this.image, this.duscription,
      this.categoryName, this.price);

  factory ProductModel.toObject(Map<String, dynamic> data) {
    return ProductModel(
        data[HelperDatabase.idProductColumn],
        data[HelperDatabase.nameProductColumn],
        data[HelperDatabase.imageProductColumn],
        data[HelperDatabase.duscriptionProductColumn],
        data[HelperDatabase.categoryNameProductColumn],
        data[HelperDatabase.priceProductColumn]);
  }
}
