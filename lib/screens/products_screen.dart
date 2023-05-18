import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/grid.dart';
import 'package:shop_app/widgets/product_item.dart';

enum FilterOptions { Favorites, All }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        // setState(() {
        _isLoading = false;
        // });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("My Shop"),
        backgroundColor: primary,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.Favorites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  "All",
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: GestureDetector(
                child: Icon(Icons.shopping_cart),
                onTap: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: accent,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : gridView(
              showFav: _showOnlyFav,
            ),
    );
  }
}
