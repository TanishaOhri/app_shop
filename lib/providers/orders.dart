import 'package:flutter/material.dart';
import 'package:shop_app/models/links.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  String? id;
  double? amount;
  List<CartItem>? products;
  DateTime? date;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.date,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  String? authToken;
  String? userId;
  Order(this.authToken, this._orders, this.userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        Links.ordercol+'$userId.json?auth=$authToken');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List)
              .map((item) => CartItem(
                    id: item['id'],
                    img: item['img'],
                    quantity: item['quantity'],
                    price: item['price'],
                    title: item['title'],
                  ))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void>? addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
         Links.ordercol+'$userId.json?auth=$authToken'); // add your realtime data collection of orders link
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    'img': cp.img,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          date: timeStamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
