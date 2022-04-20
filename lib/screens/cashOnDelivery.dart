import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/providers/order.dart';
import 'package:QuickShop/screens/paymentSuccessScreen.dart';
import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../credential.dart';

class CashOnDelivery extends StatefulWidget {
  final Map<String, Object> userDetails;
  final List<CartModel> cart;
  final String userId;
  final totalAmount;
  final String fullName;
  final String address;
  final String mobileNo;
  final String email;
  final int deliveryCharge;
  final coordinates;
  CashOnDelivery({
    this.userDetails,
    this.cart,
    this.userId,
    this.address,
    this.coordinates,
    this.email,
    this.deliveryCharge,
    this.fullName,
    this.mobileNo,
    this.totalAmount,
  });

  @override
  _CashOnDeliveryState createState() => _CashOnDeliveryState();
}

class _CashOnDeliveryState extends State<CashOnDelivery> {
  final LocalStorage storage = new LocalStorage('TUSHARGHONE');
  var orders = {};

  @override
  void initState() {
    placeOrder();
    super.initState();
  }

  void placeOrder() async {
    var products = [];

    orders['amount'] = widget.totalAmount;
    orders['userId'] = widget.userDetails == null
        ? widget.userId
        : widget.userDetails['userId'];
    orders['shopId'] = widget.cart[0].shopId;
    orders['customerName'] = widget.fullName;
    orders['customerEmail'] = widget.email;
    orders['address'] = widget.address;
    orders['latitude'] = widget.coordinates.latitude;
    orders['longitude'] = widget.coordinates.longitude;
    orders['customerNumber'] = widget.mobileNo;
    orders['paymentStatus'] = false;
    orders['deliveryCharge'] = widget.deliveryCharge;
    widget.cart.forEach((data) {
      products.add({
        "productName": data.product['productName'],
        "price": data.product['price'],
        "description": data.product['description'],
        "imageUrl": data.product['imageUrl'],
        "category": data.product['category'],
        "unit": data.product['unit'],
        "quantity": data.quantity,
      });
    });
    orders['products'] = List.from(products);
    print(orders);
    await Provider.of<Order>(context, listen: false).insertOrder(
      widget.userDetails == null ? widget.userId : widget.userDetails['userId'],
      orders['shopId'],
      orders['amount'],
      orders['products'],
      orders,
    );
    Provider.of<Cart>(context, listen: false).emptyCart();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartUpPage(index: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: width * 0.65),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.done,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: width * 0.07),
                Text(
                  'Your order has been placed!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
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
