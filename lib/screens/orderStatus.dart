import 'dart:convert';

import 'package:QuickShop/screens/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class OrderStatus extends StatefulWidget {
  final order;
  OrderStatus({this.order});

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool packed = false;
  bool shipped = false;
  bool delivered = false;

  Future<bool> _willPopCallback() async {
    Navigator.of(context).pop(widget.order.delivered);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Order Details',
          //     style: Theme.of(context).appBarTheme.textTheme.headline1,
          //   ),
          // ),
          backgroundColor: Colors.white,
          body: Container(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    color: Colors.blueAccent,
                    height: height * 0.5,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: width * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_rounded),
                                iconSize: 18.0,
                                color: Colors.white,
                                onPressed: () => Navigator.of(context)
                                    .pop(widget.order.delivered),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      '\u20b9 ${widget.order.amount}',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: width * 0.015,
                              ),
                              Text(
                                widget.order.paymentStatus
                                    ? 'Paid to'
                                    : 'Pay on delivery to',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: width * 0.012,
                              ),
                              Text(
                                widget.order.vendorName,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                widget.order.vendorNumber == null
                                    ? ''
                                    : widget.order.vendorNumber,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              widget.order.delivered
                                  ? Container(
                                      width: width,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Completed on ${DateFormat('dd-MM-yyyy hh:mm a').format(widget.order.updatedAt)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              widget.order.delivered
                                  ? SizedBox(height: width * 0.05)
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _isLoading
                  //     ? Container(
                  //         margin: EdgeInsets.only(
                  //           top: width * 0.55,
                  //           left: width * 0.06,
                  //           right: width * 0.06,
                  //         ),
                  //         child: Center(
                  //           child: CircularProgressIndicator(
                  //             backgroundColor: Colors.white,
                  //           ),
                  //         ),
                  //       )
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(
                      top: width * 0.58,
                      left: width * 0.06,
                      right: width * 0.06,
                      bottom: width * 0.09,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: width * 0.09,
                        horizontal: width * 0.03,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blueAccent,
                                child: widget.order.paymentStatus
                                    ? Icon(
                                        Icons.done,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              SizedBox(width: width * 0.04),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Products',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      'Order has been placed',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: height * 0.01),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderDetails(
                                              order: widget.order,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View product details',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: width * 0.065),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blueAccent,
                                child: widget.order.packed
                                    ? Icon(
                                        Icons.done,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '2',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              SizedBox(width: width * 0.04),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.packed ? 'Packed' : 'Pack',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      widget.order.packed
                                          ? 'The order has been packed by the vendor'
                                          : 'Your order is in under review.',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: height * 0.01),
                                    // packed
                                    //     ? CircularProgressIndicator()
                                    //     : InkWell(
                                    //         onTap: widget.order.packed
                                    //             ? null
                                    //             : () {},
                                    //         child: Text(
                                    //           widget.order.packed
                                    //               ? 'Packed'
                                    //               : 'Update packing status',
                                    //           style: TextStyle(
                                    //             fontSize: 17,
                                    //             color: widget.order.packed
                                    //                 ? Colors.grey
                                    //                 : Theme.of(context)
                                    //                     .primaryColor,
                                    //             decoration:
                                    //                 TextDecoration.underline,
                                    //           ),
                                    //           softWrap: true,
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: width * 0.065),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blueAccent,
                                child: widget.order.shipped
                                    ? Icon(
                                        Icons.done,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              SizedBox(width: width * 0.03),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.shipped ? 'Shipped' : 'Ship',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      'The order will be delivered in less than 90 minutes.',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(height: height * 0.01),
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (!widget.order.paymentStatus)
                            SizedBox(height: width * 0.09),
                          if (!widget.order.paymentStatus)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.blueAccent,
                                  child: widget.order.shipped
                                      ? Icon(
                                          Icons.done,
                                          size: 30,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          '4',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                SizedBox(width: width * 0.03),
                                Container(
                                  constraints:
                                      BoxConstraints(maxWidth: width * 0.6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.order.shipped
                                            ? 'Paid'
                                            : 'Not Paid',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        'Complete the payment when you receive your orders.',
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.grey,
                                        ),
                                        softWrap: true,
                                      ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          SizedBox(height: width * 0.09),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blueAccent,
                                child: widget.order.delivered
                                    ? Icon(
                                        Icons.done,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        widget.order.paymentStatus ? '4' : '5',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              SizedBox(width: width * 0.04),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.delivered
                                          ? 'Delivered'
                                          : 'Deliver',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      'The order will be delivered at your doorstep.',
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.grey,
                                      ),
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      height: widget.order.paymentStatus
                                          ? width * 0.08
                                          : width * 0.04,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // delivered
                                        //     ? CircularProgressIndicator()
                                        //     : InkWell(
                                        //         onTap: widget.order.delivered
                                        //             ? null
                                        //             : null,
                                        //         child: Text(
                                        //           widget.order.delivered
                                        //               ? 'Delivered'
                                        //               : 'Update delivery status',
                                        //           style: TextStyle(
                                        //             fontSize: 17,
                                        //             color:
                                        //                 widget.order.delivered
                                        //                     ? Colors.grey
                                        //                     : Theme.of(context)
                                        //                         .primaryColor,
                                        //             decoration: TextDecoration
                                        //                 .underline,
                                        //           ),
                                        //           softWrap: true,
                                        //         ),
                                        //       ),
                                        // FlatButton.icon(
                                        //   padding: EdgeInsets.all(0),
                                        //   onPressed: () {
                                        //     LatLng location = LatLng(
                                        //       double.parse(widget.order.latitude
                                        //           .toString()),
                                        //       double.parse(widget
                                        //           .order.longitude
                                        //           .toString()),
                                        //     );
                                        //   },
                                        //   icon: Icon(
                                        //     Icons.directions,
                                        //     color:
                                        //         Theme.of(context).primaryColor,
                                        //   ),
                                        //   label: Text(
                                        //     'Get Direction',
                                        //     style: TextStyle(
                                        //       fontSize: 20,
                                        //       color: Theme.of(context)
                                        //           .primaryColor,
                                        //     ),
                                        //     softWrap: true,
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
