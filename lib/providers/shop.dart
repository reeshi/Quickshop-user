import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import './location.dart';
import './product.dart';
import '../api.dart';
import '../providers/location.dart';

class ShopModel {
  final String id;
  final String ownerName;
  final String shopName;
  final String userId;
  final String imageUrl;
  final List<ProductModel> products;
  final LocationModel location;

  ShopModel({
    @required this.products,
    @required this.imageUrl,
    @required this.id,
    @required this.location,
    @required this.ownerName,
    @required this.shopName,
    @required this.userId,
  });
}

class Shop with ChangeNotifier {
  var zipcode;
  List<ShopModel> _shops = [];

  List<ShopModel> get shops {
    return [..._shops];
  }

  Shop(this.zipcode, this._shops);

  Future<void> fetchAndSetShops(
    latitude,
    longitude,
  ) async {
    try {
      var location;
      if (latitude == null || longitude == null) {
        location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }

      var body = json.encode({
        'latitude': latitude == null ? location.latitude : latitude,
        "longitude": longitude == null ? location.longitude : longitude,
      });

      final url = '$domain${endPoint['nearShop']}';

      final response = await http.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      final extractedData = json.decode(response.body);

      final List<ShopModel> extractedShop = [];
      List<ProductModel> loadedProduct = [];

      extractedData['data'].forEach((data) {
        data['products'].forEach((prod) {
          loadedProduct.add(
            ProductModel(
              productName: prod['productName'],
              category: prod['category'],
              description: prod['description'],
              id: prod['_id'],
              imageUrl: prod['imageUrl'],
              price: prod['price'].toDouble(),
              unit: prod['unit'],
              quantity: prod['quantity'] == null ? 0 : prod['quantity'],
              shopId: data['_id'],
            ),
          );
        });

        extractedShop.add(ShopModel(
          id: data['_id'],
          ownerName: data['ownerName'],
          shopName: data['shopName'],
          userId: data['userId'],
          imageUrl: data['shopImageUrl'],
          location: LocationModel(
            city: data['location']['city'],
            coordinates: data['location']['coordinates'],
            country: data['location']['country'],
            formattedAddress: data['location']['formattedAddress'],
            state: data['location']['state'],
            street: data['location']['street'],
            zipcode: data['location']['zipcode'],
          ),
          products: loadedProduct,
        ));
        loadedProduct = [];
      });
      _shops = List.from(extractedShop);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
