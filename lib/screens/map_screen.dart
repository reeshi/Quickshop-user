import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import '../credential.dart';
import '../providers/location.dart';
import '../screens/startUp_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  final String userId;
  MapScreen({this.userId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocalStorage storage = new LocalStorage('QUICKSHOP');

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<Location>(
                      builder: (ctx, loc, _) => Container(
                        width: double.infinity,
                        child: SearchMapPlaceWidget(
                          hasClearButton: true,
                          placeType: PlaceType.address,
                          placeholder: 'Enter the location',
                          apiKey: MAP_API_KEY,
                          onSelected: (Place place) async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              Geolocation geolocation = await place.geolocation;

                              final location = await loc.getLocation(
                                geolocation.coordinates,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
