import 'dart:io';

import 'package:fryo/src/cart_model.dart';
import 'package:fryo/src/product_model.dart';
import 'package:fryo/src/shared/adress_model.dart';
import 'package:fryo/src/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HelperDatabase {
  HelperDatabase._();

  static final HelperDatabase helperDatabase = new HelperDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  static String allUserTable = 'allUser';
  static String userNameColumn = 'userName';
  static String idUserColumn = 'id';
  static String emailUserColumn = 'email';
  static String passwordUserColumn = 'password';
  static String typeUserColumn = 'typeUser';
  static String productTable = 'allProduct';
  static String nameProductColumn = 'nameProduct';
  static String priceProductColumn = 'price';
  static String idProductColumn = 'id';
  static String categoryNameProductColumn = 'categoryName';
  static String duscriptionProductColumn = 'duscription';
  static String imageProductColumn = 'image';
  static String userIdProductColumn = 'userId';
  static String cartItemTable = 'cartItem';
  static String idCartItemColumn = 'id';
  static String quantityCartItemColumn = 'Quantity';
  static String productIdCartItemColumn = 'productId';
  static String adresscTaple = 'adressc';
  static String adressid = 'id';
  static String adressname = 'adressname';
  static String adresscode = 'adresscode';
  static String adresslane = 'adresslane';
  static String adresscity = 'adresscity';

  initDb() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String path = join(appDir.path, 'final.db');
      return await openDatabase(path, version: 2,
          onUpgrade: (db, oldVersion, newVersion) async {
        if (newVersion > oldVersion) {
          await db.execute('DROP TABLE IF EXISTS $allUserTable');
          await db.execute('DROP TABLE IF EXISTS $productTable');
          await db.execute('DROP TABLE IF EXISTS $cartItemTable');
          await db.execute('DROP TABLE IF EXISTS $adresscTaple');
          await db.execute('''
        CREATE TABLE $allUserTable (
        $idUserColumn INTEGER PRIMARY KEY AUTOINCREMENT ,
        $userNameColumn TEXT  , 
        $emailUserColumn TEXT , 
        $passwordUserColumn TEXT , 
        $typeUserColumn INTEGER )
        ''');
          await db.execute('''
          CREATE TABLE $productTable 
          (
          $idProductColumn INTEGER PRIMARY KEY AUTOINCREMENT ,
          $nameProductColumn TEXT , 
          $duscriptionProductColumn TEXT , 
          $priceProductColumn REAL ,
          $categoryNameProductColumn TEXT,
          $imageProductColumn TEXT,
          $userIdProductColumn INTEGER
          )
          ''');

          await db.execute('''
          CREATE TABLE $cartItemTable 
          (
          $idCartItemColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $productIdCartItemColumn INTEGER,
          $quantityCartItemColumn INTEGER
          )
          ''');
          await db.execute('''
          CREATE TABLE $adresscTaple 
          (
          $adressid INTEGER PRIMARY KEY AUTOINCREMENT , 
          $adressname TEXT , 
          $adresscode REAL ,
          $adresslane TEXT,
          $adresscity TEXT,
          )
          ''');
        }
      });
    } catch (error) {}
  }

  Future<int> signUpUser(UserModel userModel, String password) async {
    Database db = await database;
    int idUser = await db.rawInsert(
        '''INSERT INTO $allUserTable ($userNameColumn , $emailUserColumn , $passwordUserColumn , $typeUserColumn) 
                    VALUES (? , ? , ? , ?)''',
        [userModel.userName, userModel.email, password, userModel.type]);
    return idUser;
  }

  Future<UserModel> signIn(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> user = await db.query(allUserTable,
        where: '$emailUserColumn = ? AND $passwordUserColumn = ?',
        whereArgs: [email, password]);
    if (user.isNotEmpty) {
      return new UserModel.toObject(user[0]);
    } else {
      return null;
    }
  }

  addProduct(ProductModel productModel) async {
    Database db = await database;
    int idProduct = await db.rawInsert(
        '''INSERT INTO $productTable ($nameProductColumn , $duscriptionProductColumn , $imageProductColumn , $categoryNameProductColumn ,$priceProductColumn) 
                    VALUES (? , ? , ? , ? , ?)''',
        [
          productModel.name,
          productModel.duscription,
          productModel.image,
          productModel.categoryName,
          productModel.price
        ]);
  }
  addadress(adressmodel adress) async {
    Database db = await database;
    int idProduct = await db.rawInsert(
        '''INSERT INTO $adresscTaple ($adressname , $adresscode , $adresslane , $adresscity) 
                    VALUES (? , ? , ? , ?)''',
        [
          adress.adressname,
          adress.adresscode,
          adress.adresslane,
          adress.adresscity,
        ]);
  }

  Future<List<ProductModel>> getProducts() async {
    Database db = await database;
    List<Map<dynamic, dynamic>> products =
        await db.rawQuery('SELECT * FROM $productTable');
    List<ProductModel> productsModel = [];
    for (var i = 0; i < products.length; i++) {
      ProductModel productModel = ProductModel.toObject(products[i]);
      productsModel.add(productModel);
    }
    return productsModel;
  }

  addItemCart(int idProductCart, int quantity) async {
    Database db = await database;
    int idProduct = await db.rawInsert(
        '''INSERT INTO $cartItemTable ($idProductColumn , $quantityCartItemColumn) 
           VALUES (? , ? )''', [idProductCart, quantity]);
  }

  Future<List<CartModel>> getItemsCart() async {
    Database db = await database;
    List<Map<dynamic, dynamic>> cartsItems =
        await db.rawQuery('SELECT * FROM $cartItemTable');
    List<CartModel> carts = [];
    for (var i = 0; i < cartsItems.length; i++) {
      int idProduct = cartsItems[i][idProductColumn];
      List<Map<dynamic, dynamic>> product = await db
          .rawQuery('SELECT * FROM $productTable WHERE id = ?', [idProduct]);

      ProductModel productModel = ProductModel.toObject(product[0]);
      CartModel cartModel = new CartModel(cartsItems[i][idCartItemColumn],
          cartsItems[i][quantityCartItemColumn], productModel);
      carts.add(cartModel);
    }
    return carts;
  }

  removeFromCart(int id) async {
    Database db = await database;
    await db.delete(cartItemTable, where: 'id = ?', whereArgs: [id]);
  }
//getUser() async {
//    Database db = await database;
//    List<Map<dynamic, dynamic>> users =
//        await db.rawQuery('SELECT * FROM $allUserTable');
//    users.forEach((element) {
//      print(element.toString());
//    });
//  }
//
}
