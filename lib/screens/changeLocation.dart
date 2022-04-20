import 'package:QuickShop/providers/location.dart';
import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';

import '../credential.dart';

class ChangeLocation extends StatefulWidget {
  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Change Location',
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
        ),
        body: SingleChildScrollView(
          child: _isLoading
              ? Container(
                  margin: EdgeInsets.only(top: height * 0.2),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      child: SearchMapPlaceWidget(
                        hasClearButton: true,
                        placeType: PlaceType.address,
                        placeholder: 'Enter the location',
                        apiKey: MAP_API_KEY,
                        onSelected: (Place place) async {
                          setState(() {
                            _isLoading = true;
                          });
                          Geolocation geolocation = await place.geolocation;

                          final coordinates = Coordinates(
                              geolocation.coordinates.latitude,
                              geolocation.coordinates.longitude);

                          final address = await Geocoder.local
                              .findAddressesFromCoordinates(coordinates);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StartUpPage(
                                index: 0,
                                latitude: geolocation.coordinates.latitude,
                                longitude: geolocation.coordinates.longitude,
                                address: address.first.addressLine,
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: width * 0.09),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          width: width * 0.7,
          child: FlatButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              final location = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              final coordinates =
                  Coordinates(location.latitude, location.longitude);

              final address = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartUpPage(
                    index: 0,
                    latitude: location.latitude,
                    longitude: location.longitude,
                    address: address.first.addressLine,
                  ),
                ),
              );

              setState(() {
                _isLoading = false;
              });
            },
            child: Text(
              'Use current location',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
