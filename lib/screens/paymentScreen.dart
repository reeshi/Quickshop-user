import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/screens/paymentSuccessScreen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../credential.dart';

class PurchaseScreen extends StatefulWidget {
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
  PurchaseScreen({
    this.userDetails,
    this.cart,
    this.deliveryCharge,
    this.userId,
    this.address,
    this.coordinates,
    this.email,
    this.fullName,
    this.mobileNo,
    this.totalAmount,
  });

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Razorpay _razorPay;
  final LocalStorage storage = new LocalStorage('TUSHARGHONE');
  var orders = {};

  @override
  void initState() {
    var products = [];
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
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
    orders['paymentStatus'] = true;
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
    getPayment();
    super.initState();
  }

  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }

  void paymentError(PaymentFailureResponse error) {
    print("Error: " + error.message + error.code.toString());
    if (error.message != null) {
      print('failure');
      Navigator.of(context).pop(true);
    }
  }

  void paymentSuccess(PaymentSuccessResponse paymentSuccessResponse) async {
    print("Success: " + paymentSuccessResponse.orderId.toString());
    if (paymentSuccessResponse.paymentId != null) {
      print('success');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            userDetails: widget.userDetails,
            orders: orders,
            userId: widget.userId,
          ),
        ),
      );
    }
  }

  getPayment() {
    var options = {
      'key': '$RAZOR_PAY_KEY',
      'amount': 1 * 100, //in the smallest currency sub-unit.
      'name': 'Shop Owner',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Products',
      'timeout': 90, // in seconds
      'prefill': {'contact': widget.mobileNo, 'email': widget.email}
    };

    try {
      _razorPay.open(options);
    } catch (e) {
      print('on Error:' + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
