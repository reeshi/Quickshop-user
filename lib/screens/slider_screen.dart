import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import './auth_screen.dart';

class SliderScreen extends StatelessWidget {
  static const routeName = '/slider';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              child: Carousel(
                showIndicator: false,
                boxFit: BoxFit.cover,
                animationDuration: Duration(milliseconds: 600),
                images: [
                  AssetImage('assets/images/fresh.jpg'),
                  AssetImage('assets/images/fast.jpg'),
                  AssetImage('assets/images/pay.jpg')
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          },
          label: Text('Skip'),
        ),
      ),
    );
  }
}
