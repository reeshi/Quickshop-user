import 'dart:convert';
import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var userDetails;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await storage.ready;
    userDetails = json.decode(storage.getItem('userDetails'));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Widget buildListTile(String title, String icon, Function tapHandler) {
      // return ListTile(
      //   leading: SvgPicture.asset(
      //     icon,
      //     height: 20,
      //     width: 20,
      //   ),
      //   title: Text(
      //     title,
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 22,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   onTap: tapHandler,
      // );
      return GestureDetector(
        onTap: tapHandler,
        child: Container(
          height: width * 0.1,
          padding: EdgeInsets.only(left: width * 0.045),
          margin: EdgeInsets.only(bottom: width * 0.03),
          alignment: Alignment.center,
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 22,
                width: 22,
              ),
              SizedBox(width: width * 0.04),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(40, 40, 40, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Drawer(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      bottom: width * 0.04,
                      top: width * 0.04,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: userDetails['userImage'] == null
                            ? AssetImage('assets/images/6.jpg')
                            : NetworkImage(userDetails['userImage']),
                      ),
                      title: Text(
                        userDetails['fullName'] == null
                            ? ""
                            : userDetails['fullName'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(40, 40, 40, 1),
                        ),
                      ),
                      subtitle: Text(
                        userDetails['email'] == null
                            ? ""
                            : userDetails['email'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  buildListTile(
                    'Home',
                    'assets/svgIcons/home.svg',
                    () {
                      Navigator.of(context).pushNamed(StartUpPage.routeName);
                    },
                  ),
                  SizedBox(height: width * 0.015),
                  buildListTile(
                    'My Orders',
                    'assets/svgIcons/order.svg',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartUpPage(
                              index: 3,
                            ),
                          ));
                    },
                  ),
                  SizedBox(height: width * 0.015),
                  buildListTile(
                    'My Cart',
                    'assets/svgIcons/shopping-cart.svg',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartUpPage(
                              // formProductScreen: false,
                              // userId: userDetails['userId'],
                              index: 2,
                            ),
                          ));
                    },
                  ),
                  SizedBox(height: width * 0.015),
                  buildListTile(
                    'Profile',
                    'assets/svgIcons/user.svg',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartUpPage(
                              index: 4,
                            ),
                          ));
                    },
                  ),
                  SizedBox(height: width * 0.015),
                  buildListTile(
                    'Logout',
                    'assets/svgIcons/logout.svg',
                    () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                      await storage.deleteItem('userDetails');
                      //Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
                    },
                  ),
                  SizedBox(height: width * 0.035),
                ],
              ),
      ),
    );
  }
}
