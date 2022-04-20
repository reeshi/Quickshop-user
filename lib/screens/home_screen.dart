import 'dart:convert';

import 'package:QuickShop/screens/changeLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../providers/shop.dart';
import '../widgets/shop_item.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
import '../providers/location.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final Function drawer;
  final latitude;
  final longitude;
  final String address;
  HomeScreen({
    this.drawer,
    this.latitude,
    this.address,
    this.longitude,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var _isLoading = false;
  Map<String, dynamic> userDetails;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await storage.ready;
    userDetails = json.decode(storage.getItem('userDetails'));
    Provider.of<Shop>(context, listen: false)
        .fetchAndSetShops(
      widget.latitude,
      widget.longitude,
    )
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<AutoCompleteTextFieldState<String>> _search = GlobalKey();
    final shop = Provider.of<Shop>(context).shops;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(userDetails);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: userDetails == null
              ? Text('')
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeLocation(),
                        ));
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgIcons/location.svg',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Flexible(
                        child: Text(
                          userDetails['formattedAddress'] == null
                              ? 'Select Location'
                              : widget.address == null
                                  ? '${userDetails['formattedAddress']}'
                                  : widget.address,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          softWrap: false,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
          leading: Container(
            padding: EdgeInsets.only(left: width * 0.02),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/svgIcons/more.svg',
                height: 27,
                width: 27,
              ),
              onPressed: () {
                widget.drawer();
              },
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    Provider.of<Shop>(context, listen: false).fetchAndSetShops(
                  widget.latitude,
                  widget.longitude,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: shop.length == 0
                      ? Container(
                          height: height * 0.6,
                          alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Text(
                              'No Shop found in your area!\n Try to change the current location by clicking on appbar.',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                  top: width * 0.032,
                                  left: width * 0.034,
                                ),
                                child: Text(
                                  'Nearby Shops ( ${shop.length} ):',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ...shop.map(
                                (shopData) => ShopItem(
                                  shopData,
                                  userDetails['userId'],
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
