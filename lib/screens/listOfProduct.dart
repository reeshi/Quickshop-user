import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/providers/product.dart';
import 'package:QuickShop/screens/myCart_screen.dart';
import 'package:QuickShop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProduct extends StatefulWidget {
  final List<ProductModel> products;
  final String userId;
  final String shopId;
  ListOfProduct({
    this.products,
    this.shopId,
    this.userId,
  });
  @override
  _ListOfProductState createState() => _ListOfProductState();
}

Future<bool> _willPopCallback(BuildContext context) async {
  Navigator.of(context).pop();
  return true;
}

class _ListOfProductState extends State<ListOfProduct> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final cart = Provider.of<Cart>(context).cart;
    return WillPopScope(
      onWillPop: () => _willPopCallback(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'List of Products',
              style: Theme.of(context).appBarTheme.textTheme.headline1,
            ),
            // actions: [
            //   FlatButton(
            //     onPressed: () {},
            //     child: Icon(
            //       Icons.shopping_cart_sharp,
            //       color: Colors.white,
            //     ),
            //   )
            // ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: widget.products.length == 0
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: width * 0.04),
                          child: Text(
                            'No products found.Add some products!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(bottom: width * 0.15),
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => ProductItem(
                            product: widget.products[i],
                            userId: widget.userId,
                            shopId: widget.shopId,
                            cart: cart,
                          ),
                          itemCount: widget.products.length,
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: width * 0.8,
            height: width * 0.14,
            margin: EdgeInsets.only(bottom: width * 0.08),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyCartScreen(
                      formProductScreen: true,
                      cart: cart,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              textColor: Colors.white,
              child: Text(
                "Go to Cart",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
