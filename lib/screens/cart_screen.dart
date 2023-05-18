import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cartitem = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: primary,
      ),
      body: cartitem.items!.isEmpty
          ? Center(
              child: Container(
                child: Image.asset('assets/images/cart_empty.png'),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 549.h,
                  child: ListView.builder(
                      itemCount: cartitem.items!.length,
                      itemBuilder: (context, index) => CartTile(
                            id: cartitem.items!.values.toList()[index].id,
                            price: cartitem.items!.values.toList()[index].price,
                            quantity:
                                cartitem.items!.values.toList()[index].quantity,
                            title: cartitem.items!.values.toList()[index].title,
                            img: cartitem.items!.values.toList()[index].img,
                            productId: cartitem.items!.keys.toList()[index],
                          )),
                ),
                Container(
                  color: primary,
                  child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total: ",
                                style: title1,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "₹ " + cartitem.totalAmount.toString(),
                                style: title1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: 300.w,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: cartitem.totalAmount! <= 0
                                  ? null
                                  : () async {
                                      await Provider.of<Order>(context,
                                              listen: false)
                                          .addOrder(
                                              cartitem.items!.values.toList(),
                                              cartitem.totalAmount!);
                                      cartitem.clear();
                                    },
                              child: Text(
                                "CHECKOUT",
                                style: heading,
                              ),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
    );
  }
}
