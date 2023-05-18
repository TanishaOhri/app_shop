import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/cart.dart';

class CartTile extends StatelessWidget {
  CartTile(
      {Key? key,
      this.productId,
      this.id,
      this.img,
      this.price,
      this.quantity,
      this.title})
      : super(key: key);
  String? title;
  String? img;
  String? id;
  double? price;
  double? quantity;
  String? productId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        color: primary,
        height: 200.h,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Image.network(
                img!,
                fit: BoxFit.cover,
                height: 200.h,
                width: 130.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 170.w,
                        child: AutoSizeText(
                          title!,
                          style: style,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('Do you want to remove this item?'),
                              title: Text("Are you sure?"),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(primary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("NO"),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(primary),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Provider.of<Cart>(context, listen: false)
                                          .removeItem(productId!);
                                    },
                                    child: Text("YES")),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 120.w,
                        child: AutoSizeText(
                          "₹ " + price!.toString(),
                          style: style,
                        ),
                      ),
                      Container(
                        width: 74.w,
                        child: Text(
                          quantity!.toString() + ' x',
                          textAlign: TextAlign.end,
                          style: title2,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
