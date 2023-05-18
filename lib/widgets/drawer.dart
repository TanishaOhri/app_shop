import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/login.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details.dart';
import 'package:shop_app/screens/products_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBar(
                title: Text("Hello! How are you? "),
                automaticallyImplyLeading: false,
                backgroundColor: primary,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.shop,
                  color: primary,
                ),
                title: Text(
                  "Shop",
                  style: heading,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsScreen()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: primary,
                ),
                title: Text("Orders", style: heading),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderScreen()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: primary,
                ),
                title: Text("Manage Products", style: heading),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: primary,
            ),
            title: Text(
              "LOGOUT",
              style: heading,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
