import 'dart:convert';
import 'package:QuickShop/providers/order.dart';
import 'package:QuickShop/screens/orderDetails.dart';
import 'package:QuickShop/screens/orderStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  final Function drawer;
  OrderHistoryScreen({this.drawer});
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderModel> orders = [];
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var _isLoading = true;
  Map<String, dynamic> userDetails;
  int deliveryCharge = 30;

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  fetchOrder() async {
    await storage.ready;
    userDetails = json.decode(storage.getItem('userDetails'));
    final List<OrderModel> loadedOrder =
        await Provider.of<Order>(context, listen: false)
            .fetchUserOrder(userDetails['userId']);
    if (loadedOrder != null) {
      orders = List.from(loadedOrder);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'My Orders',
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
          leading: Container(
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
                height: height,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: orders.length == 0
                    ? SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(top: width * 0.5),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                child: SvgPicture.asset(
                                  'assets/svgIcons/order.svg',
                                  height: height * 0.15,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: width * 0.03),
                                child: Text(
                                  'No order placed yet!',
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
                                            'Looks like you haven\'t ordered \n',
                                      ),
                                      TextSpan(
                                        text: 'anything cart yet.',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.03),
                              child: Text(
                                'Your Order ( ${orders.length} ):',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ...orders.map((order) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderStatus(order: order),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: width * 0.02,
                                    bottom: width * 0.03,
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: width * 0.04,
                                        horizontal: width * 0.02,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.black26,
                                                    backgroundImage:
                                                        order.shopImage != null
                                                            ? NetworkImage(
                                                                order.shopImage)
                                                            : null,
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.05),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  width * 0.5),
                                                      child: Text(
                                                        'Ordered from ${order.shopName}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  width * 0.5),
                                                      child: Text(
                                                        'Order placed at : ${DateFormat('dd-MM-yyyy hh:mm a').format(order.createdAt)} ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  width * 0.54),
                                                      child: Text(
                                                        order.delivered
                                                            ? 'Delivered: ${DateFormat('dd-MM-yyyy hh:mm a').format(order.updatedAt)}'
                                                            : 'Not delivered yet',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              order.delivered
                                                                  ? 16
                                                                  : 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              child: IconButton(
                                            padding: EdgeInsets.only(
                                                right: width * 0.03),
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderStatus(order: order),
                                                ),
                                              );
                                            },
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
