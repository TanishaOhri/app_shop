import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersfuture;
  Future? _obtainOrdersFuture() {
    return Provider.of<Order>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersfuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
          backgroundColor: primary,
        ),
        body: FutureBuilder(
          future: _ordersfuture,
          builder: (context, datSnapshot) {
            if (datSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (datSnapshot.error != null) {
                return Text('error occured');
              } else {
                return Consumer<Order>(
                    builder: (context, ordersList, _) => ListView.builder(
                          itemCount: ordersList.orders.length,
                          itemBuilder: (context, index) => OrderTile(
                            order: ordersList.orders[index],
                          ),
                        ));
              }
            }
          },
        ));
  }
}
