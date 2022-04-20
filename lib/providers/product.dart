import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String productName;
  final double price;
  final String description;
  final String imageUrl;
  final String category;
  final String unit;
  final int quantity;
  final String shopId;

  ProductModel({
    this.shopId,
    @required this.category,
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    this.unit,
    this.quantity,
    @required this.productName,
  });
}

class Product with ChangeNotifier {
  final List<ProductModel> _product = [];

  List<ProductModel> get products {
    return [..._product];
  }
}
