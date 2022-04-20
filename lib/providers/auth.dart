import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api.dart';
import '../helper/handler.dart';

class Account {
  final String fullName;
  final String mobileNo;
  final String userImage;
  final String email;
  final String address;
  final String zipcode;

  Account({
    this.email,
    this.zipcode,
    this.mobileNo,
    this.address,
    this.userImage,
    this.fullName,
  });
}

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  var _zipcode;
  String _address = "";

  String get address {
    return _address;
  }

  String get zipcode {
    return _zipcode;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  bool get auth {
    return token != null;
  }

  void logout() async {
    _token = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  login(String email, String password) async {
    try {
      final url = '$domain${endPoint['login']}';

      var body =
          json.encode({"email": email, "password": password, "role": "user"});

      final response = await http.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      final extractedData = json.decode(response.body);

      _token = extractedData['token'];
      _userId = extractedData['userId'];
      _zipcode = extractedData['zipcode'];
      _address = extractedData['address'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'address': _address,
          'zipcode': _zipcode
        },
      );
      prefs.setString('user', userData);
      notifyListeners();
      if (extractedData['error'] != null) {
        throw ErrorHandler(extractedData['error']);
      }
      print(extractedData);
      return extractedData;
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final url = '$domain${endPoint['register']}';

      var body =
          json.encode({"email": email, "password": password, "role": "user"});

      final response = await http.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      final extractedData = json.decode(response.body);
      // _token = extractedData['token'];
      _userId = extractedData['userId'];
      notifyListeners();
      if (extractedData['error'] != null) {
        throw ErrorHandler(extractedData['error']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('user')) as Map<String, Object>;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _address = extractedData['address'];
    _zipcode = extractedData['zipcode'];
    notifyListeners();
    return true;
  }

  fetchUser(userId) async {
    final url = '$domain${endPoint['fetchUser']}';
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
    final user = Account(
      email: extractedData['data']['email'],
      mobileNo: extractedData['data']['mobileNo'],
      fullName: extractedData['data']['fullName'],
      userImage: extractedData['data']['userImage'],
      address: extractedData['data']['location']['formattedAddress'],
      zipcode: extractedData['data']['zipcode'],
    );
    return user;
  }

  updateUser(
    String userId,
    String fullName,
    String address,
    String mobileNo,
    String userImage,
  ) async {
    final url = '$domain${endPoint['updateUser']}';
    var body = json.encode({
      "userId": userId,
      "fullName": fullName,
      "address": address,
      "mobileNo": mobileNo,
      "userImage": userImage,
    });

    final response = await http.put(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
      },
    );

    final extractedData = json.decode(response.body);
    final user = Account(
      email: extractedData['data']['email'],
      mobileNo: extractedData['data']['mobileNo'],
      fullName: extractedData['data']['fullName'],
      userImage: extractedData['data']['userImage'],
      address: extractedData['data']['location']['formattedAddress'],
    );
    return user;
  }
}
