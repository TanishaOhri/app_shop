import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_produxt.dart';

class UserTile extends StatelessWidget {
  UserTile({Key? key, this.img, this.price, this.title, this.id})
      : super(key: key);
  String? title;
  String? id;
  String? img;
  double? price;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          color: primary,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5.w),
                child: Image.network(
                  img!,
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 140.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 140.w,
                          child: AutoSizeText(
                            title!,
                            style: style,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Addproduct.routeName, arguments: id);
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onTap: () async {
                            try {
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .deleteProduct(id!);
                            } catch (error) {
                              SnackBar(
                                content: Text('Cannot be deleted'),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120.h,
                    ),
                    Container(
                      width: 120.w,
                      child: AutoSizeText(
                        "₹ " + price!.toString(),
                        style: style,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
