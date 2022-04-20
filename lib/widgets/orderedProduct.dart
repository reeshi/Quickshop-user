import 'package:flutter/material.dart';

class OrderedProduct extends StatelessWidget {
  final Map<String, dynamic> product;
  OrderedProduct({this.product});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
          top: width * 0.02,
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
              vertical: width * 0.035,
              horizontal: width * 0.03,
            ),
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
                          backgroundImage: product['imageUrl'] != null
                              ? NetworkImage(product['imageUrl'])
                              : null,
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: width * 0.38),
                            child: Text(
                              '${product['productName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Text(
                            'Amount: ${product['quantity'] * product['price']} ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          // Text(
                          //   'Not delivered yet',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 16,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(width * 0.04),
                  child: Text(
                    'x ${product['quantity']}',
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
