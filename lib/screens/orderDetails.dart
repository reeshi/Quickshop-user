import 'package:QuickShop/widgets/orderedProduct.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final order;
  OrderDetails({this.order});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  getTotalAmount() {
    int total = 0;
    widget.order.product.forEach((data) {
      total += data['quantity'] * data['price'];
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Details',
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
        ),
        body: Container(
          height: height,
          width: width,
          margin: EdgeInsets.symmetric(
            vertical: width * 0.03,
            horizontal: width * 0.04,
          ),
          child: Column(
            children: [
              ...widget.order.product.map(
                (product) => OrderedProduct(
                  product: product,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: width * 0.15,
                  left: width * 0.055,
                  right: width * 0.055,
                  bottom: width * 0.1,
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vendor',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.02),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.4),
                          child: Text(
                            '${widget.order.vendorName}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.4),
                          child: Text(
                            '${widget.order.vendorEmail}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Contact No:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.4),
                          child: Text(
                            widget.order.vendorNumber == null
                                ? 'Not added'
                                : widget.order.vendorNumber,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //
                    SizedBox(height: width * 0.05),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Item ( ${widget.order.product.length} )',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\u20b9 ${getTotalAmount()}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery charge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\u20b9 ${widget.order.deliveryCharge}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\u20b9 ${getTotalAmount() + widget.order.deliveryCharge}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
