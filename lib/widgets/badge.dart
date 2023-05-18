import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:shop_app/constants/style.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget? child;
  final String? value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        Positioned(
          right: 8.w,
          top: 8.h,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              // color: color != null ? color : accent,
            ),
            constraints: BoxConstraints(
              minWidth: 10.w,
              minHeight: 10.h,
            ),
            child: Text(
              value!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
