import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/exception.dart';
import 'package:shop_app/models/links.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;
  Products(this.authToken, this._items, this.userId);
  List<Product> _items = [];

  var _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favorite {
    return _items.where((pro) => pro.isFav!).toList();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final url =
        Uri.parse(Links.filter + 'auth=$authToken&$filterString'); // add
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final urlFav = Uri.parse(Links.prodcol +
          '$userId.json?auth=$authToken'); // add your realtime data collection of products link
      final favoriteResponse = await http.get(urlFav);
      final favData = json.decode(favoriteResponse.body);
      final List<Product> loadedList = [];
      extractedData.forEach((prodId, prodData) {
        loadedList.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData["description"],
          price: prodData['price'],
          imageurl: prodData['imageurl'],
          isFav: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void>? addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-22923-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageurl': product.imageurl,
            'isFav': product.isFav,
            'userId': userId,
          },
        ),
      );
      final newPro = Product(
        title: product.title,
        imageurl: product.imageurl,
        price: product.price,
        description: product.description,
        id: json.decode(response.body)['name'],
      );
      _items.add(newPro);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void>? updateProduct(String id, Product newPro) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-22923-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

      await http.patch(url,
          body: json.encode({
            'title': newPro.title,
            'description': newPro.description,
            'price': newPro.price,
            'imageurl': newPro.imageurl,
          }));
      _items[prodIndex] = newPro;
    }
    notifyListeners();
  }

  Future<void>? deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-22923-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingPro = _items[existingIndex];

    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingPro);
      notifyListeners();
      throw HttpException(message: 'Could not delete');
    }
    existingPro = null;
    _items.removeAt(existingIndex);
    notifyListeners();
  }
}
