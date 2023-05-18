import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class gridView extends StatelessWidget {
  const gridView({
    Key? key,
    this.showFav,
  }) : super(key: key);
  final bool? showFav;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav! ? productsData.favorite : productsData.items;
    return (showFav == true && productsData.favorite.isEmpty)
        ? Center(
            child: Container(
              child: Image.asset('assets/images/wishlist.png'),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(5.h),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.w,
                childAspectRatio: 0.78,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 10.w),
            itemCount: products.length,
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: products[index], child: ProductItem()));
  }
}
