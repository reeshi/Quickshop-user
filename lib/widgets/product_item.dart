import 'package:QuickShop/helper/handler.dart';
import 'package:QuickShop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../screens/product_description.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  final String userId;
  final String shopId;
  final cart;
  ProductItem({
    this.product,
    this.cart,
    this.shopId,
    this.userId,
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int quantity = 0;
  String cartId;
  void _showDialodBox(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure you want to clear cart?',
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          'Products are already added in the cart from another shop.',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              await Provider.of<Cart>(context, listen: false)
                  .deleteCartProduct(widget.userId);
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text(
              'No',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  insertCart() async {
    setState(() {
      quantity = quantity + 1;
    });
    var product = {
      "productName": widget.product.productName,
      "price": widget.product.price,
      "description": widget.product.description,
      "imageUrl": widget.product.imageUrl,
      "category": widget.product.category,
      "unit": widget.product.unit,
      'id': widget.product.id,
    };
    try {
      final cart =
          await Provider.of<Cart>(context, listen: false).insertIntoCart(
        widget.userId,
        widget.shopId,
        quantity,
        product,
      );
      setState(() {
        cartId = cart;
      });
    } on ErrorHandler catch (err) {
      var message = err.message;
      if (err.message.toString() == 'SHOP_NOT_MATCHED') {
        message = "SHOP_NOT_MATCHED";
      }
      setState(() {
        quantity = quantity - 1;
      });
      _showDialodBox(message);
    } catch (err) {
      _showDialodBox(err.message);
    }
  }

  @override
  void initState() {
    super.initState();
    setQuantity();
  }

  setQuantity() {
    widget.cart.forEach((data) {
      if (data.product['id'] == widget.product.id) {
        quantity = data.quantity;
        cartId = data.cartId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   ProductDescriptionScreen.routeName,
        //   arguments: widget.product,
        // );
      },
      child: Container(
        margin: EdgeInsets.all(width * 0.02),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey[300],
          ),
        ]),
        child: Card(
          elevation: 0,
          shadowColor: Colors.grey,
          child: Container(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black26,
                          backgroundImage: widget.product.imageUrl != null
                              ? NetworkImage(widget.product.imageUrl)
                              : null,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxHeight: width * 0.5),
                            child: Text(
                              '${widget.product.productName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.product.category}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          // Text(
                          //   'Quantity: ${widget.product.quantity}',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          Text(
                            '\u20b9${widget.product.price} per ${widget.product.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: width * 0.07),
                  child: quantity == 0
                      ? RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: insertCart,
                          color: Color.fromRGBO(29, 73, 255, 1),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                setState(() {
                                  quantity = quantity + 1;
                                });
                                await Provider.of<Cart>(context, listen: false)
                                    .updateCart(
                                  widget.userId,
                                  cartId,
                                  true,
                                );
                              },
                            ),
                            SizedBox(width: width * 0.008),
                            Text(
                              quantity.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(width: width * 0.008),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () async {
                                setState(() {
                                  quantity = quantity - 1;
                                });
                                if (quantity == 0) {
                                  await Provider.of<Cart>(context,
                                          listen: false)
                                      .deleteFromCart(
                                    widget.userId,
                                    cartId,
                                  );
                                } else {
                                  await Provider.of<Cart>(context,
                                          listen: false)
                                      .updateCart(
                                    widget.userId,
                                    cartId,
                                    false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
