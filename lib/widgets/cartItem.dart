import 'package:QuickShop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final CartModel cart;
  final Function removeFromCart;
  final String userId;
  CartItem({
    this.cart,
    this.removeFromCart,
    this.userId,
  });
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Dismissible(
      key: ValueKey(widget.cart.cartId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(
          left: width * 0.045,
          right: width * 0.045,
          top: width * 0.04,
        ),
        padding: EdgeInsets.only(right: width * 0.03),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        Provider.of<Cart>(context, listen: false)
            .deleteFromCart(widget.userId, widget.cart.cartId);
        widget.removeFromCart(widget.cart.cartId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
                content: Text(
                  'Do you want to remove this item from the cart?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.only(
          left: width * 0.045,
          right: width * 0.045,
          top: width * 0.04,
        ),
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
                          backgroundImage: widget.cart.product['imageUrl'] !=
                                  null
                              ? NetworkImage(widget.cart.product['imageUrl'])
                              : null,
                        ),
                      ),
                      SizedBox(width: width * 0.07),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.cart.product['productName']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            '${widget.cart.product['category']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '\u20b9 ${widget.cart.product['price']} per ${widget.cart.product['unit']}',
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
                  margin: EdgeInsets.all(width * 0.04),
                  child: Text(
                    'x ${widget.cart.quantity}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
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
