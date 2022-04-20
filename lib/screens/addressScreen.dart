import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/providers/location.dart';
import 'package:QuickShop/screens/cashOnDelivery.dart';
import 'package:QuickShop/screens/paymentScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final userDetails;
  final List<CartModel> cart;
  final int deliveryCharge;
  final Function getTotalAmount;
  AddressScreen({
    this.userDetails,
    this.getTotalAmount,
    this.deliveryCharge,
    this.cart,
  });
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _fullNameController = TextEditingController();
  var _addressController = TextEditingController();
  var _emailCOntroller = TextEditingController();
  var _mobileController = TextEditingController();
  bool currentAddress = false;
  bool address = false;
  bool _isLoading = false;
  FocusNode mobileFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var coordinates;
  var cords;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userDetails['fullName'];
    _emailCOntroller.text = widget.userDetails['email'];
    _addressController.text = widget.userDetails['formattedAddress'];
    _mobileController.text = widget.userDetails['mobileNo'];
    fetchLocation();
  }

  fetchLocation() async {
    final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    cords = Coordinates(location.latitude, location.longitude);
  }

  onlinePayment() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseScreen(
          userDetails: widget.userDetails,
          cart: widget.cart,
          userId: widget.userDetails['userId'],
          totalAmount: widget.getTotalAmount() + widget.deliveryCharge,
          address: _addressController.text,
          coordinates: coordinates == null ? cords : coordinates,
          email: _emailCOntroller.text,
          fullName: _fullNameController.text,
          deliveryCharge: widget.deliveryCharge,
          mobileNo: _mobileController.text,
        ),
      ),
    ).then((value) {
      if (value) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transaction failed!',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  cashOnDelivery() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CashOnDelivery(
          userDetails: widget.userDetails,
          cart: widget.cart,
          userId: widget.userDetails['userId'],
          totalAmount: widget.getTotalAmount() + widget.deliveryCharge,
          address: _addressController.text,
          coordinates: coordinates == null ? cords : coordinates,
          email: _emailCOntroller.text,
          fullName: _fullNameController.text,
          mobileNo: _mobileController.text,
          deliveryCharge: widget.deliveryCharge,
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    setState(() {
      mobileFocus.unfocus();
      addressFocus.unfocus();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: InkWell(
        onTap: () {
          setState(() {
            mobileFocus.unfocus();
            addressFocus.unfocus();
          });
        },
        child: Container(
          padding: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: width * 0.03,
            bottom: mobileFocus.hasFocus || addressFocus.hasFocus
                ? width * 0.55
                : 0,
          ),
          height: height * 0.85,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Delivery Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        alignment: Alignment.centerLeft,
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(thickness: 1.3),
                  SizedBox(height: height * 0.015),
                  Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        top: width * 0.0001,
                        bottom: width * 0.01,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            // initialValue: userDetails.fullNameController,
                            controller: _fullNameController,

                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide full name';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   return fullNameController = value.trim();
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        top: width * 0.034,
                        bottom: width * 0.01,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            // initialValue: userDetails.email,
                            controller: _emailCOntroller,
                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                              enabled: false,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide email address';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        top: width * 0.034,
                        bottom: width * 0.01,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.01,
                      right: width * 0.01,
                      // bottom: height * 0.02,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            // initialValue: userDetails.mobileNo,
                            controller: _mobileController,
                            focusNode: mobileFocus,
                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                              counterText: '',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Please enter valid phone number';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   return _mobileController = value.trim();
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //     padding: EdgeInsets.only(
                  //       left: width * 0.01,
                  //       right: width * 0.01,
                  //       top: width * 0.0001,
                  //       bottom: width * 0.01,
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.max,
                  //       children: <Widget>[
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: <Widget>[
                  //             Text(
                  //               'Address',
                  //               style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.black87,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     )),
                  Theme(
                    data: ThemeData(
                        dividerColor: Colors.transparent,
                        textTheme: Theme.of(context).textTheme),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: width * 0.01,
                      ),
                      title: Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      childrenPadding: EdgeInsets.only(left: width * 0.01),
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              address = false;
                              currentAddress = true;
                              _isLoading = true;
                            });
                            try {
                              final location =
                                  await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high,
                              );

                              final coords = Coordinates(
                                  location.latitude, location.longitude);

                              final address = await Geocoder.local
                                  .findAddressesFromCoordinates(coords);
                              setState(() {
                                _addressController.text =
                                    '${address[0].addressLine}';
                                coordinates = coords;
                                _isLoading = false;
                              });
                            } catch (err) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: width * 0.03),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgIcons/location.svg',
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(width: width * 0.01),
                                _isLoading
                                    ? Container(
                                        height: height * 0.01,
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'Use current location',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       address = true;
                        //       currentAddress = false;
                        //     });
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.only(bottom: width * 0.03),
                        //     child: Row(
                        //       children: [
                        //         SvgPicture.asset(
                        //           'assets/svgIcons/location.svg',
                        //           height: 15,
                        //           width: 15,
                        //         ),
                        //         SizedBox(width: width * 0.01),
                        //         Text(
                        //           'Enter manually',
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.w500,
                        //             color: Colors.black87,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // if (address)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.01,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  // initialValue: userDetails.address,
                                  controller: _addressController,
                                  style: TextStyle(fontSize: 19),
                                  maxLines: 3,
                                  focusNode: addressFocus,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: width * 0.01,
                                    ),
                                    hintText: "Address",
                                    hintStyle: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please provide address';
                                    }
                                    return null;
                                  },
                                  // onSaved: (value) {
                                  //   return address = value.trim();
                                  // },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: width * 0.01,
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     children: <Widget>[
                  //       Flexible(
                  //         child: TextFormField(
                  //           // initialValue: userDetails.address,
                  //           controller: _addressController,
                  //           style: TextStyle(fontSize: 19),
                  //           maxLines: 2,
                  //           decoration: InputDecoration(
                  //             hintText: "Address",
                  //             hintStyle: TextStyle(
                  //               fontSize: 16.0,
                  //             ),
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           validator: (value) {
                  //             if (value.isEmpty) {
                  //               return 'Please provide address';
                  //             }
                  //             return null;
                  //           },
                  //           // onSaved: (value) {
                  //           //   return address = value.trim();
                  //           // },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width * 0.4,
                        height: width * 0.12,
                        margin: EdgeInsets.only(
                          bottom: width * 0.08,
                          left: width * 0.02,
                        ),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              'Cash on delivery',
                              style: TextStyle(fontSize: textScale * 20),
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            cashOnDelivery();
                          },
                        ),
                      ),
                      Container(
                        width: width * 0.4,
                        height: width * 0.12,
                        margin: EdgeInsets.only(bottom: width * 0.08),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              'Online payment',
                              style: TextStyle(fontSize: textScale * 20),
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            onlinePayment();
                          },
                        ),
                      ),
                    ],
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
