import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    Key? key,
  }) : super(key: key);
  // String? title;
  static const routeName = '/product-detail';

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadProduct = Provider.of<Products>(context).findById(productId);
    final cartpro = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadProduct.title!),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              loadProduct.imageurl!,
              fit: BoxFit.cover,
              height: 410.h,
              width: 375.w,
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loadProduct.title!,
                    style: cartheading,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '₹ ${loadProduct.price}',
                    style: heading,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Details:\n' + loadProduct.description!,
                    style: heading,
                  ),
                ],
              ),
            ),
            Container(
              color: primary,
              child: Padding(
                padding: EdgeInsets.all(10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          loadProduct.toggleFav(authData.token!,authData.userId!);
                        });
                      },
                      child: Icon(
                        loadProduct.isFav!
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 45.h,
                      ),
                    ),
                    Container(
                      width: 300.w,
                      height: 57.1.h,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Text(
                          "ADD TO BAG",
                          style: heading,
                        ),
                        onPressed: () {
                          setState(() {
                            cartpro.addItem(
                              loadProduct.id!,
                              loadProduct.title!,
                              loadProduct.price!,
                              loadProduct.imageurl!,
                            );
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
