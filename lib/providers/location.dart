import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api.dart';
import '../credential.dart';

class LocationModel {
  final List coordinates;
  final String formattedAddress;
  final String city;
  final String state;
  final String zipcode;
  final String country;
  final String street;

  LocationModel({
    @required this.city,
    @required this.coordinates,
    @required this.country,
    @required this.formattedAddress,
    @required this.state,
    @required this.street,
    @required this.zipcode,
  });
}

class Location with ChangeNotifier {
  var latitude;
  var longitude;
  var addr;

  String _address;
  static String zipcode;

  String userId;
  Location(this.userId);

  String get address {
    return _address;
  }

  // String get zip {
  //   return _zipcode;
  // }

   getLocation(LatLng coord,String user) async {
    if (coord == null) {
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final coordinates = Coordinates(location.latitude, location.longitude);

      final address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      final url = '$domain${endPoint['location']}$user';

      final addr = json.encode({'address': address.first.addressLine});

      final response = await http.put(
        url,
        body: addr,
        headers: {"Content-Type": "application/json"},
      );

      final extractedData = json.decode(response.body);

      // _address = extractedData['data']['location']['formattedAddress'];
      // zipcode = extractedData['data']['location']['zipcode'];

      print(response.body);
      return extractedData['data'];
    } else {
      final url = '$domain${endPoint['location']}$user';

      final coordinates = Coordinates(coord.latitude, coord.longitude);

      final address = await Geocoder.google(MAP_API_KEY)
          .findAddressesFromCoordinates(coordinates);

      final addr = json.encode({
        'address': address.first.addressLine,
        'state': address.first.adminArea
      });

      final response = await http.put(
        url,
        body: addr,
        headers: {"Content-Type": "application/json"},
      );
      final extractedData = json.decode(response.body);
      // _address = extractedData['data']['location']['formattedAddress'];
      // zipcode = extractedData['data']['location']['zipcode'];
      print(_address);
      return extractedData['data'];
    }
  }
}
