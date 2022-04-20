import 'dart:async';

import 'package:flutter/material.dart';

import './slider_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushNamed(SliderScreen.routeName);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 130,
                backgroundImage: AssetImage('assets/images/logo.jpg'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                child: Image.asset(
                  'assets/images/cart.gif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
