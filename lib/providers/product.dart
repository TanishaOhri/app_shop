import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/links.dart';

class Product with ChangeNotifier {
  String? id;
  String? title;
  String? description;
  double? price;
  String? imageurl;
  bool? isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageurl,
    this.isFav = false,
  });

  void toggleFav(String token, String userId) async {
    final oldStatus = isFav;
    isFav = !isFav!;
    notifyListeners();
    final sendFav = json.encode(isFav);
    final url = Uri.parse(
       Links.prodcol+'$userId/$id.json?auth=$token'); // add your realtime data collection of products link
    try {
      await http.put(url, body: sendFav);
    } catch (e) {
      isFav = oldStatus;
      notifyListeners();
      print(e);
    }
  }
}
