import 'package:fryo/src/product_model.dart';

class CartModel{
  int id;
  int quantity;
  ProductModel productModel;

  CartModel(this.id, this.quantity, this.productModel);


}