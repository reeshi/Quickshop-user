import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/providers/order.dart';
import 'package:QuickShop/screens/orderHistory_screen.dart';
import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final userDetails;
  final orders;
  final String userId;
  PaymentSuccessScreen({
    this.userDetails,
    this.orders,
    this.userId,
  });
  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    insertOrder();
  }

  insertOrder() async {
    await Provider.of<Order>(context, listen: false).insertOrder(
      widget.userDetails == null ? widget.userId : widget.userDetails['userId'],
      widget.orders['shopId'],
      widget.orders['amount'],
      widget.orders['products'],
      widget.orders,
      
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
            margin: EdgeInsets.only(top: width * 0.7),
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
                  'Your payment is done successfully!',
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
