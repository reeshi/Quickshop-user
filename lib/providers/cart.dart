import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../helper/handler.dart';

class CartModel {
  final product;
  final int quantity;
  final String shopId;
  final String userId;
  final String cartId;

  CartModel({
    this.cartId,
    this.product,
    this.quantity,
    this.shopId,
    this.userId,
  });
}

class Cart with ChangeNotifier {
  List<CartModel> _cart = [];

  List<CartModel> get cart {
    return [..._cart];
  }

  fetchUserCart(
    String userId,
  ) async {
    final url = '$domain${endPoint['fetchUserCart']}';
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
    final List<CartModel> loadedCart = [];
    if (extractedData['data'] == null) {
      return;
    }
    extractedData['data'].forEach((cart) {
      loadedCart.add(CartModel(
        cartId: cart['_id'],
        product: cart['product'],
        quantity: cart['quantity'],
        shopId: cart['shopId'],
        userId: cart['userId'],
      ));
    });
    _cart = List.from(loadedCart);
    return loadedCart;
  }

  insertIntoCart(
    String userId,
    String shopId,
    int quantity,
    var product,
  ) async {
    try {
      final url = '$domain${endPoint['insertIntoCart']}';
      var body = json.encode({
        "userId": userId,
        "shopId": shopId,
        "quantity": quantity,
        "product": product
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
        _cart.add(CartModel(
          cartId: extractedData['data']['_id'],
          product: extractedData['data']['product'],
          quantity: extractedData['data']['quantity'],
          shopId: extractedData['data']['shopId'],
          userId: extractedData['data']['userId'],
        ));
        notifyListeners();
        return extractedData['data']['_id'];
      }
    } catch (err) {
      throw err;
    }
  }

  deleteFromCart(
    String userId,
    String cartId,
  ) async {
    final url = '$domain${endPoint['deleteFromCart']}';
    var body = json.encode({
      "userId": userId,
      "cartId": cartId,
    });

    final response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );

    final extractedData = json.decode(response.body);
    if (extractedData['data'] == []) {
      _cart.removeWhere((cart) => cart.cartId == cartId);
    }
    notifyListeners();
  }

  deleteCartProduct(
    String userId,
  ) async {
    final url = '$domain${endPoint['deleteCartProduct']}';
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
    if (extractedData['data'] == []) {
      _cart = [];
    }
    notifyListeners();
  }

  updateCart(
    String userId,
    String cartId,
    bool increment,
  ) async {
    final url = '$domain${endPoint['updateCart']}';
    var body = json.encode({
      "userId": userId,
      "cartId": cartId,
      "increment": increment,
    });

    final response = await http.put(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );

    final extractedData = json.decode(response.body);
    // if (extractedData['data']) {
    //   _cart.fir
    // }
    notifyListeners();
  }

  emptyCart() {
    _cart = [];
    notifyListeners();
  }
}
