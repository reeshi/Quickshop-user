import 'dart:convert';
import 'dart:io';

import 'package:QuickShop/providers/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final Function drawer;
  ProfileScreen({this.drawer});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalStorage storage = new LocalStorage('QUICKSHOP');
  var fullName = '';
  var address = '';
  var _emailText = '';
  var _mobileText = '';
  final _formKey = GlobalKey<FormState>();
  Account userDetails;
  String imageUrl = '';
  var userInfo;

  var pickedImage = '';
  bool _isLoading = false;

  var _pickedImage;

  void _imgFromCamera() async {
    final picker = ImagePicker();

    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    final userId = Provider.of<Auth>(context, listen: false).userId;

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('userImage_' + userId + '.jpg');

    await ref.putFile(pickedImageFile);

    var image = await ref.getDownloadURL();
    setState(() {
      imageUrl = image;
    });
  }

  _imgFromGallery() async {
    final picker = ImagePicker();

    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });

    final userId = Provider.of<Auth>(context, listen: false).userId;

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('userImage_' + userId + '.jpg');

    await ref.putFile(pickedImageFile);

    var image = await ref.getDownloadURL();
    setState(() {
      imageUrl = image;
    });
    print(imageUrl);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    setState(() {
      _isLoading = true;
    });
    await storage.ready;
    userInfo = json.decode(storage.getItem('userDetails'));
    userDetails = await Provider.of<Auth>(context, listen: false)
        .fetchUser(userInfo['userId']);
    setState(() {
      _isLoading = false;
    });
  }

  void save() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final Account user =
        await Provider.of<Auth>(context, listen: false).updateUser(
      userInfo['userId'],
      fullName,
      address,
      _mobileText,
      imageUrl == '' ? userDetails.userImage : imageUrl,
    );

    storage.setItem(
      'userDetails',
      json.encode({
        'userId': userInfo['userId'],
        'token': userInfo['token'],
        'formattedAddress': userInfo['formattedAddress'],
        'zipcode': userInfo['zipcode'],
        'email': userInfo['email'],
        'userImage': user.userImage,
        'fullName': user.fullName,
        'mobileNo': user.mobileNo,
      }),
    );
    setState(() {
      userDetails = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style: Theme.of(context).appBarTheme.textTheme.headline1),
          leading: Container(
            padding: EdgeInsets.only(left: height * 0.02),
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
        body: Container(
          height: height,
          width: width,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: width,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Stack(
                              fit: StackFit.loose,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: height * 0.25,
                                      height: height * 0.25,
                                      margin:
                                          EdgeInsets.only(top: width * 0.04),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: _pickedImage == null
                                            ? userDetails.userImage == null
                                                ? Image.asset(
                                                    'assets/images/6.jpg',
                                                    fit: BoxFit.fill,
                                                  )
                                                : FadeInImage(
                                                    placeholder: AssetImage(
                                                        'assets/images/6.jpg'),
                                                    image: NetworkImage(
                                                      userDetails.userImage,
                                                    ),
                                                    fit: BoxFit.fill,
                                                  )
                                            : Image.file(
                                                _pickedImage,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: width * 0.45,
                                    right: width * 0.3,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          _showPicker(context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          radius: 20.0,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.1),
                          Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.07,
                                right: width * 0.03,
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
                            padding: EdgeInsets.only(
                              left: height * 0.03,
                              right: height * 0.03,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    initialValue: userDetails.fullName,
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
                                    onSaved: (value) {
                                      return fullName = value.trim();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.07,
                                right: width * 0.03,
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
                            padding: EdgeInsets.only(
                              left: height * 0.03,
                              right: height * 0.03,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    initialValue: userDetails.email,
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
                                left: width * 0.07,
                                right: width * 0.03,
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
                              left: height * 0.03,
                              right: height * 0.03,
                              bottom: height * 0.03,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    initialValue: userDetails.mobileNo,
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
                                    onSaved: (value) {
                                      return _mobileText = value.trim();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.07,
                                right: width * 0.03,
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
                                        'Address',
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
                              left: height * 0.03,
                              right: height * 0.03,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    initialValue: userDetails.address,
                                    style: TextStyle(fontSize: 19),
                                    maxLines: 2,
                                    decoration: InputDecoration(
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
                                    onSaved: (value) {
                                      return address = value.trim();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.05),
                          Center(
                            child: Container(
                              width: width * 0.7,
                              height: width * 0.12,
                              margin: EdgeInsets.only(bottom: width * 0.08),
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  save();
                                },
                                textColor: Colors.white,
                                child: Text(
                                  "Update",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
