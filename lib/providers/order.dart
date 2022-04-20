import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../helper/handler.dart';

class OrderModel {
  final product;
  final int amount;
  final String shopId;
  final String userId;
  final String orderId;
  final String shopName;
  final String shopImage;
  final DateTime createdAt;
  DateTime updatedAt;
  final String customerName;
  final String customerNumber;
  final String email;
  final String address;
  final latitude;
  final longitude;
  bool paymentStatus;
  bool packed;
  bool shipped;
  bool delivered;
  final String vendorName;
  final String vendorEmail;
  final String vendorNumber;
  final int deliveryCharge;

  OrderModel({
    this.orderId,
    this.createdAt,
    this.shopName,
    this.shopImage,
    this.product,
    this.amount,
    this.shopId,
    this.userId,
    this.address,
    this.customerName,
    this.customerNumber,
    this.email,
    this.latitude,
    this.longitude,
    this.delivered = false,
    this.packed = false,
    this.paymentStatus = false,
    this.shipped = false,
    this.deliveryCharge,
    this.updatedAt,
    this.vendorEmail,
    this.vendorName,
    this.vendorNumber,
  });
}

class Order with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders {
    return [..._orders];
  }

  fetchUserOrder(
    String userId,
  ) async {
    final url = '$domain${endPoint['fetchUserOrder']}';
    var body = json.encode({
      "userId": userId,
    });

    final response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );

    final extractedData = json.decode(response.body);
    List<OrderModel> loadedOrder = [];
    if (extractedData['data'] == null) {
      return;
    }
    extractedData['data'].forEach((order) {
      loadedOrder.add(
        OrderModel(
          orderId: order['_id'],
          product: List.from(order['products']),
          amount: order['amount'],
          shopId: order['shopId'],
          userId: order['userId'],
          shopImage: order['shopImage'],
          shopName: order['shopName'],
          createdAt: DateTime.parse(order['createdAt']),
          customerName: order['customerName'],
          customerNumber: order['customerNumber'],
          email: order['email'],
          address: order['customerAddress']['address'],
          latitude: order['customerAddress']['coordinates']['latitude'],
          longitude: order['customerAddress']['coordinates']['longitude'],
          updatedAt: DateTime.parse(order['updatedAt']),
          delivered: order['delivered'],
          packed: order['packed'],
          paymentStatus: order['paymentStatus'],
          shipped: order['shipped'],
          vendorEmail: order['vendorEmail'],
          vendorName: order['vendorName'],
          vendorNumber: order['vendorNumber'],
          deliveryCharge: order['deliveryCharge'],
        ),
      );
    });
    _orders = List.from(loadedOrder);
    return loadedOrder;
  }

  insertOrder(
    String userId,
    String shopId,
    int amount,
    List product,
    var orders,
  ) async {
    try {
      final url = '$domain${endPoint['insertOrder']}';
      var body = json.encode({
        "userId": userId,
        "shopId": shopId,
        "amount": amount,
        "packed": false,
        "shipped": false,
        "delivered": false,
        "products": List.from(product),
        'customerName': orders['customerName'],
        "paymentStatus": orders['paymentStatus'],
        'customerNumber': orders['customerNumber'],
        'customerEmail': orders['customerEmail'],
        'customerAddress': {
          'address': orders['address'],
          'coordinates': {
            'latitude': orders['latitude'],
            'longitude': orders['longitude']
          },
        },
        'deliveryCharge': orders['deliveryCharge'],
        'createdAt': DateTime.now().toIso8601String(),
      });
      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      final extractedData = json.decode(response.body);
      if (extractedData['error'] == 'SHOP_NOT_MATCHED') {
        throw ErrorHandler(extractedData['error']);
      } else {
        // _orders.add(OrderModel(
        //   orderId: extractedData['data']['_id'],
        //   product: List.from(extractedData['data']['products']),
        //   amount: extractedData['data']['amount'],
        //   shopId: extractedData['data']['shopId'],
        //   userId: extractedData['data']['userId'],
        //   shopImage: extractedData['data']['shopImage'],
        //   shopName: extractedData['data']['shopName'],
        //   createdAt: DateTime.parse(extractedData['data']['createdAt']),

        // ));
        notifyListeners();
        return extractedData['data'];
      }
    } catch (err) {
      throw err;
    }
  }
}
