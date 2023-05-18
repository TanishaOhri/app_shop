import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/add_produxt.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/login.dart';
import 'package:shop_app/screens/product_details.dart';
import 'package:shop_app/screens/products_screen.dart';

import 'providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(370, 730),
      builder: (_, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, prevPoducts) => Products(
              auth.token,
              prevPoducts == null ? [] : prevPoducts.items,
              auth.userId,
            ),
            create: (context) => Products(null, [], ""),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (context, auth, prevOrders) => Order(auth.token,
                prevOrders == null ? [] : prevOrders.orders, auth.userId),
            create: (context) => Order(null, [], ""),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: authData.isAuth!
                ? ProductsScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (context, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: Text('Loading'),
                                ),
                              )
                            : LoginPage(),
                  ),
            routes: {
              ProductDetails.routeName: (context) => ProductDetails(),
              CartScreen.routeName: (context) => CartScreen(),
              Addproduct.routeName: (context) => Addproduct(),
            },
          ),
        ),
      ),
    );
  }
}
