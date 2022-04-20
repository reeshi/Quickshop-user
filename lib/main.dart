import 'package:QuickShop/providers/cart.dart';
import 'package:QuickShop/providers/order.dart';
import 'package:QuickShop/screens/home_screen.dart';
import 'package:QuickShop/screens/startUp_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/slider_screen.dart';
import './screens/auth_screen.dart';
import 'screens/startUp_screen.dart';
import 'screens/user_location.dart';
import './screens/map_screen.dart';
import 'providers/location.dart';
import './providers/auth.dart';
import './providers/shop.dart';
import './providers/product.dart';
// import './screens/splash.dart';
import './screens/product_description.dart';
import 'screens/categoryScreen.dart';
import './helper/custom_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Location>(
            create: null,
            update: (ctx, auth, previousLocation) => Location(
              auth.userId,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Shop>(
            create: null,
            update: (ctx, auth, previousShop) => Shop(
              auth.zipcode,
              previousShop == null ? [] : previousShop.shops,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Product(),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Order(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QuickShop',
            theme: ThemeData(
              primarySwatch: Colors.green,
              fontFamily: 'MarkaziText',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline1: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DancingScript',
                      ),
                    ),
              ),
            ),
            home: authData.auth
                ? StartUpPage()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshots) =>
                        authResultSnapshots.connectionState ==
                                ConnectionState.waiting
                            ? AuthScreen()
                            : AuthScreen(),
                  ),
            // home:AuthScreen(),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              SliderScreen.routeName: (ctx) => SliderScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              StartUpPage.routeName: (ctx) => StartUpPage(),
              UserLocation.routeName: (ctx) => UserLocation(),
              MapScreen.routeName: (ctx) => MapScreen(),
              ProductScreen.routeName: (ctx) => ProductScreen(),
              ProductDescriptionScreen.routeName: (ctx) =>
                  ProductDescriptionScreen(),
            },
          ),
        ));
  }
}
