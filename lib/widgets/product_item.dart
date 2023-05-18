import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final pro = Provider.of<Product>(context);
    final cartpro = Provider.of<Cart>(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductDetails.routeName,
                  arguments: pro.id,
                );
              },
              child: Image.network(
                pro.imageurl!,
                fit: BoxFit.cover,
                height: 140.h,
                width: 170.w,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 35.h,
                        child: AutoSizeText(
                          pro.title!,
                          style: heading,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        '₹ ${pro.price}',
                        style: subheading,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Icon(
                    pro.isFav! ? Icons.favorite : Icons.favorite_border,
                    color: primary,
                  ),
                  onTap: () {
                    setState(() {
                      pro.toggleFav(authData.token!, authData.userId!);
                    });
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.shopping_cart,
                    color: primary,
                  ),
                  onTap: () {
                    setState(() {
                      cartpro.addItem(
                        pro.id!,
                        pro.title!,
                        pro.price!,
                        pro.imageurl!,
                      );
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added item to cart"),
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cartpro.removeSingleItem(pro.id!);
                              }),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
