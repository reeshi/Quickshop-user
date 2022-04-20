import 'dart:convert';

import 'package:QuickShop/screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'home_screen.dart';
import 'myCart_screen.dart';
import 'orderHistory_screen.dart';
import '../widgets/drawer.dart';

class StartUpPage extends StatefulWidget {
  static const routeName = '/main';
  final int index;
  final latitude;
  final longitude;
  final String address;
  StartUpPage({
    this.index,
    this.latitude,
    this.address,
    this.longitude,
  });

  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  int _selectedPageIndex = 0;
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> userDetails;

  void openDraw() {
    _scaffoldKey.currentState.openDrawer();
  }

  List<Map<String, Object>> _pages;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  showExitAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Do you want to Exit?',
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).errorColor,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'No',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    showExitAlert(context);
    return true;
  }

  @override
  void initState() {
    if (widget.index != null) {
      _selectedPageIndex = widget.index;
    }
    _pages = [
      {
        'page': HomeScreen(
          drawer: openDraw,
          longitude: widget.longitude,
          latitude: widget.latitude,
          address:widget.address,
        ),
        'title': 'Home',
      },
      {
        'page': MyCartScreen(
          formProductScreen: false,
          drawer: openDraw,
        ),
        'title': 'MyCart',
      },
      {
        'page': OrderHistoryScreen(
          drawer: openDraw,
        ),
        'title': 'MyOrders',
      },
      {
        'page': ProfileScreen(
          drawer: openDraw,
        ),
        'title': 'Profile',
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          body: _pages[_selectedPageIndex]['page'],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _selectPage,
            elevation: 10,
            selectedItemColor: Colors.green[600],
            currentIndex: _selectedPageIndex,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 20,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgIcons/home.svg',
                  height: 20,
                  width: 20,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgIcons/shopping-cart.svg',
                  height: 20,
                  width: 20,
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgIcons/order.svg',
                  height: 20,
                  width: 20,
                ),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svgIcons/user.svg',
                  height: 20,
                  width: 20,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
