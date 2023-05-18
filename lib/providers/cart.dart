import 'package:flutter/material.dart';

class CartItem {
  String? id;
  String? title;
  double? quantity;
  double? price;
  String? img;

  CartItem({this.id, this.price, this.quantity, this.title, this.img});
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};
  Map<String, CartItem>? get items {
    return {..._items!};
  }

  int get itemCount {
    return _items!.length;
  }

  double? get totalAmount {
    double total = 0;
    _items!.forEach((key, cartitem) {
      total += cartitem.price! * cartitem.quantity!;
    });
    return total;
  }

  void removeItem(String? id) {
    _items!.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_items!.containsKey(prodId)) {
      return;
    }
    if (_items![prodId]!.quantity! > 1) {
      _items!.update(
          prodId,
          (exist) => CartItem(
              id: exist.id!,
              title: exist.title!,
              img: exist.img!,
              price: exist.price!,
              quantity: exist.quantity! - 1));
    } else {
      _items!.remove(prodId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void addItem(String id, String title, double price, String img) {
    if (_items!.containsKey(id)) {
      _items!.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              img: existing.img,
              quantity: existing.quantity! + 1));
    } else {
      _items!.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            img: img,
            quantity: 1),
      );
    }
    notifyListeners();
  }
}
