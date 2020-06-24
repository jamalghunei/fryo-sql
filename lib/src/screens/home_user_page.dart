import 'package:flutter/material.dart';
import 'package:fryo/src/helper_database.dart';
import 'package:fryo/src/product_model.dart';
import 'package:fryo/src/shared/colors.dart';
import 'package:fryo/src/shared/fryo_icons.dart';
import 'package:fryo/src/shared/partials.dart';
import 'package:fryo/src/shared/styles.dart';

import 'ProductPage.dart';

class HomeUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeUserPage();
  }
}

class _HomeUserPage extends State<HomeUser> {
  Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 86,
              height: 86,
              child: FloatingActionButton(
                shape: CircleBorder(),
                heroTag: name,
                onPressed: onPressed,
                backgroundColor: white,
                child: Icon(icon, size: 35, color: Colors.black87),
              )),
          Text(name + ' ›', style: categoryText)
        ],
      ),
    );
  }

  Widget headerTopCategories() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('shoes', Icons.add, onPressed: () {}),
              headerCategoryItem('Man', Fryo.food, onPressed: () {}),
              headerCategoryItem('Kids', Fryo.poop, onPressed: () {}),
              headerCategoryItem('T-shirt', Fryo.coffee_cup, onPressed: () {}),
            ],
          ),
        )
      ],
    );
  }



  List<ProductModel> products = [];
  @override
  void initState() {
    super.initState();

    HelperDatabase.helperDatabase.getProducts().then((value) {
      setState(() {
        products = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        headerTopCategories(),
        Expanded(
            child: GridView.builder(
              itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2 , mainAxisSpacing: 10 , crossAxisSpacing: 10),
                itemBuilder: (c , index){
                  return InkWell(onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new ProductPage(
                            productData: products[index],
                          );
                        },
                      ),
                    );
                  },child: productItem(products[index] , imgWidth: 300 , isProductPage: false));
                }))
      ],
    );
  }
}
