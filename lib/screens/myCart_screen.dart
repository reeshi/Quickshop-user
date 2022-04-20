import 'dart:convert';

import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/screens/addressScreen.dart';
import 'package:QuickShop/screens/paymentScreen.dart';
import 'package:QuickShop/widgets/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class MyCartScreen extends StatefulWidget {
  final bool formProductScreen;
  final List<CartModel> cart;
  final Function drawer;
  final String userId;
  MyCartScreen({
    this.formProductScreen,
    this.cart,
    this.userId,
    this.drawer,
  });
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<CartModel> cart = [];
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var _isLoading = false;
  Map<String, dynamic> userDetails;
  int deliveryCharge = 30;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  fetchCart() async {
    setState(() {
      _isLoading = true;
    });
    await storage.ready;
    userDetails = json.decode(storage.getItem('userDetails'));
    final List<CartModel> loadedCart =
        await Provider.of<Cart>(context, listen: false)
            .fetchUserCart(userDetails['userId']);
    if (loadedCart != null) {
      cart = List.from(loadedCart);
    }
    applyDiscountOnTotalAmount();

    setState(() {
      _isLoading = false;
    });
  }

  removeFromCart(String cartId) {
    setState(() {
      cart.removeWhere((cart) => cart.cartId == cartId);
    });
  }

  getTotalAmount() {
    int total = 0;
    cart.forEach((data) {
      total += data.quantity * data.product['price'];
    });
    return total;
  }

  var minimumOrder;
  bool order = true;

  applyDiscountOnTotalAmount() {
    if (getTotalAmount() < 99) {
      setState(() {
        minimumOrder = 'Order amount should be greater than \u20b9 100';
        order = false;
      });
    } else if (getTotalAmount() >= 100 && getTotalAmount() < 300) {
      setState(() {
        minimumOrder =
            'To avoid delivery charges, the order amount\n should be greater than \u20b9 300';
        order = false;
      });
    } else {
      setState(() {
        minimumOrder = '';
        order = true;
        deliveryCharge = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(cart);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cart',
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
          leading: widget.formProductScreen
              ? null
              : Container(
                  padding: EdgeInsets.only(left: height * 0.02),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgIcons/more.svg',
                      height: 27,
                      width: 27,
                    ),
                    onPressed: () {
                      widget.drawer();
                    },
                  ),
                ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: cart.length == 0
                    ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          height: height * 0.7,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                child: SvgPicture.asset(
                                  'assets/svgIcons/shopping-cart.svg',
                                  height: height * 0.15,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: width * 0.03),
                                child: Text(
                                  'Your Cart is Empty',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: width * 0.024),
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22,
                                      fontFamily: 'MarkaziText',
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Looks like you haven\'t added \n',
                                      ),
                                      TextSpan(
                                        text: 'anything to your cart yet.',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ...cart.map(
                              (cartData) => CartItem(
                                cart: cartData,
                                removeFromCart: removeFromCart,
                                userId: userDetails == null
                                    ? widget.userId
                                    : userDetails['userId'],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: width * 0.2,
                                left: width * 0.055,
                                right: width * 0.055,
                                bottom: width * 0.1,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Item ( ${cart.length} )',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text(
                                        'Delivery Charge',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\u20b9 ${getTotalAmount()}',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: width * 0.02),
                                      Text(
                                        '\u20b9 $deliveryCharge',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: width * 0.055,
                                right: width * 0.055,
                              ),
                              child: Divider(thickness: 1.3),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: width * 0.055,
                                right: width * 0.055,
                                top: width * 0.017,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '\u20b9 ${getTotalAmount() + deliveryCharge}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            !order
                                ? Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                      left: width * 0.057,
                                    ),
                                    child: Text(
                                      minimumOrder,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Container(
                              width: width * 0.9,
                              height: width * 0.14,
                              margin: EdgeInsets.only(
                                  bottom: width * 0.08, top: width * 0.05),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                onPressed: minimumOrder ==
                                            'To avoid delivery charges, the order amount\n should be greater than \u20b9 300' ||
                                        minimumOrder == ''
                                    ? () {
                                        showModalBottomSheet(
                                          context: (context),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                            ),
                                          ),
                                          builder: (context) => GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: AddressScreen(
                                              userDetails: userDetails,
                                              deliveryCharge: deliveryCharge,
                                              getTotalAmount: getTotalAmount,
                                              cart: cart,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                textColor: Colors.white,
                                child: Text(
                                  "CONFIRM & PROCEED",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: cart.length == 0
        //     ? SizedBox.shrink()
        //     : Container(
        //         width: width * 0.9,
        //         height: width * 0.14,
        //         margin: EdgeInsets.only(bottom: width * 0.08),
        //         child: RaisedButton(
        //           color: Theme.of(context).primaryColor,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(30),
        //           ),
        //           onPressed: minimumOrder ==
        //                       'To avoid delivery charges, the order amount\n should be greater than \u20b9 300' ||
        //                   minimumOrder == ''
        //               ? () {
        //                   showModalBottomSheet(
        //                     context: (context),
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.only(
        //                         topLeft: Radius.circular(25),
        //                         topRight: Radius.circular(25),
        //                       ),
        //                     ),
        //                     builder: (context) => GestureDetector(
        //                       behavior: HitTestBehavior.opaque,
        //                       child: AddressScreen(
        //                         userDetails: userDetails,
        //                         deliveryCharge: deliveryCharge,
        //                         getTotalAmount: getTotalAmount,
        //                         cart: cart,
        //                       ),
        //                     ),
        //                   );
        //                 }
        //               : null,
        //           textColor: Colors.white,
        //           child: Text(
        //             "CONFIRM & PROCEED",
        //             style: TextStyle(fontSize: 25),
        //           ),
        //         ),
        //       ),
      ),
    );
  }
}
