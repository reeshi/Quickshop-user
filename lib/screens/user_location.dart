import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../providers/location.dart';
import 'map_screen.dart';
import './startUp_screen.dart';

class UserLocation extends StatefulWidget {
  static const routeName = '/user-location';
  final String userId;
  UserLocation({this.userId});

  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final LocalStorage storage = new LocalStorage('QUICKSHOP');

  bool _isLoading = false;

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Choose your delivery location',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'MarkaziText',
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.05),
                    Text(
                      'Enter location for ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: width * 0.03),
                    Text(
                      'Fast Delivery',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MarkaziText',
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: width * 0.05),
                    Container(
                      width: width * 0.6,
                      child: FlatButton.icon(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        label: Text(
                          'Search for address',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.5,
                      child: Divider(
                        color: Colors.black,
                        height: 2,
                      ),
                    ),
                    SizedBox(height: width * 0.05),
                    Text(
                      'Or',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: width * 0.05),
                    Consumer<Location>(
                      builder: (ctx, loc, _) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FlatButton.icon(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              final location = await loc.getLocation(
                                null,
                                widget.userId,
                              );

                              storage.setItem(
                                  'userDetails',
                                  json.encode({
                                    'userId': widget.userId,
                                    'formattedAddress': location['location']
                                        ['formattedAddress'],
                                    'zipcode': location['location']['zipcode'],
                                    'email': location['email'],
                                  }));
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.of(context)
                                  .pushReplacementNamed(StartUpPage.routeName);
                            } catch (err) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          icon: Icon(Icons.location_on_rounded),
                          label: Text(
                            'Use my location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
