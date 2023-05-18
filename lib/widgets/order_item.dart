import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/orders.dart';

class OrderTile extends StatefulWidget {
  OrderTile({Key? key, this.order}) : super(key: key);
  final OrderItem? order;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10.h),
      child: Column(
        children: [
          ListTile(
              title: Text(
                "₹ ${widget.order!.amount}",
                style: heading,
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy').format(
                  widget.order!.date!,
                ),
                style: subheading,
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              )),
          if (_expanded)
            Container(
              height: min(widget.order!.products!.length * 20.h + 200.h, 90.h),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: ListView.builder(
                  itemCount: widget.order!.products!.length,
                  itemBuilder: (context, i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order!.products![i].title!,
                        style: heading,
                      ),
                      Text(
                        '${widget.order!.products![i].quantity!} x ₹ ${widget.order!.products![i].price}',
                        style: heading,
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
