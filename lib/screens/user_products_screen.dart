import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_produxt.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_item.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void>? _refresh(BuildContext context) async {
      Provider.of<Products>(context, listen: false).fetchProducts(true);
    }

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        backgroundColor: primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Addproduct.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _refresh(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refresh(context)!,
                      child: Consumer<Products>(
                        builder: (context, productsData, _) => Center(
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (context, i) => UserTile(
                              img: productsData.items[i].imageurl,
                              price: productsData.items[i].price,
                              title: productsData.items[i].title,
                              id: productsData.items[i].id,
                            ),
                          ),
                        ),
                      ),
                    )),
    );
  }
}
