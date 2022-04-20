import 'dart:convert';

import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'user_location.dart';
import '../providers/auth.dart';
import '../helper/handler.dart';

enum AuthMode { Login, Register }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalStorage storage = new LocalStorage('QUICKSHOP');

  final _form = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _showDialodBox(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An error occured!',
          style: TextStyle(fontSize: 20),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Okay',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(),
                  ));
            },
          )
        ],
      ),
    );
  }

  _save() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        final userDetails = await Provider.of<Auth>(context, listen: false)
            .login(_email, _password);

        storage.setItem(
          'userDetails',
          json.encode({
            'userId': userDetails['user']['_id'],
            'token': userDetails['token'],
            'formattedAddress': userDetails['user']['location'] == null
                ? ''
                : userDetails['user']['location']['formattedAddress'],
            'zipcode': userDetails['user']['location'] == null
                ? ''
                : userDetails['user']['location']['zipcode'],
            'email': userDetails['user']['email'],
            'fullName': userDetails['user']['fullName'] == null
                ? ''
                : userDetails['user']['fullName'],
            'mobileNo': userDetails['user']['mobileNo'] == null
                ? ''
                : userDetails['user']['mobileNo'],
            'userImage': userDetails['user']['userImage'] == null
                ? ''
                : userDetails['user']['userImage'],
          }),
        );
        if (userDetails['user']['location'] == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserLocation(
                  userId: userDetails['user']['_id'],
                ),
              ));
        } else {
          Navigator.of(context).pushReplacementNamed(
            StartUpPage.routeName,
          );
        }
      } else if (_authMode == AuthMode.Register) {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_email, _password);
        setState(() {
          _isLoading = false;
          _authMode = AuthMode.Login;
        });
      }
    } on ErrorHandler catch (err) {
      var message = err.message;
      if (err.message.toString() == 'NO_INPUT') {
        message = "Please enter email and password";
      } else if (err.message.toString() == 'INVALID_EMAIL') {
        message = "Please enter a valid email and password.";
      } else if (err.message.toString() == 'INVALID_PASSWORD') {
        message = "Please enter a valid password.";
      } else if (err.message.toString() == 'EMAIL_EXIST') {
        message = "Email address is already in use.";
      }
      _showDialodBox(message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      _showDialodBox('Server Error Occured');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _authMode == AuthMode.Login ? 'Login' : 'Register',
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(width * 0.07),
            margin: EdgeInsets.only(top: width * 0.1),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: width * 0.4,
                    child: Image.asset('assets/images/logo1.jpg'),
                  ),
                  SizedBox(height: width * 0.05),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    style: TextStyle(fontSize: 22),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.newline,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      return _email = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    obscureText: true,
                    style: TextStyle(fontSize: 22),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      if (value.length < 6) {
                        return 'Password length should be 6 or more.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      return _password = value;
                    },
                    onFieldSubmitted: (_) {
                      _save();
                    },
                  ),
                  SizedBox(height: width * 0.05),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          width: width * 0.7,
                          height: width * 0.12,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onPressed: _save,
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              _authMode == AuthMode.Login ? 'Login' : 'Signup',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  SizedBox(height: width * 0.05),
                  InkWell(
                    onTap: () {
                      _switchAuthMode();
                    },
                    child: Text(
                      _authMode == AuthMode.Login
                          ? "Don't have an account?Create one"
                          : 'I already have an account!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
