import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fryo/src/cart_model.dart';
import 'package:fryo/src/helper_database.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartPageS();
  }
}

class CartPageS extends State<CartPage> {
  Widget createCartListItem(image, name, amount, price, d, id) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        image: MemoryImage(base64Decode(image)))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          name,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        d,
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              (amount * price).toString(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      amount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: InkWell(
              onTap: () async {
                await HelperDatabase.helperDatabase.removeFromCart(id);
                setState(() {
                  HelperDatabase.helperDatabase.getItemsCart().then((value) {
                    setState(() {
                      c = value;
                    });
                  });
                });
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.green),
          ),
        )
      ],
    );
  }

  List<CartModel> c = [];

  @override
  void initState() {
    super.initState();

    HelperDatabase.helperDatabase.getItemsCart().then((value) {
      setState(() {
        c = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: c.length,
        itemBuilder: (cc, i) {
          return createCartListItem(
              c[i].productModel.image,
              c[i].productModel.name,
              c[i].quantity,
              c[i].productModel.price,
              c[i].productModel.duscription,
              c[i].id);
        },
      ),
    );
  }
}
