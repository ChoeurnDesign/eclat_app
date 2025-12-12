import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistService extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  int get itemCount => _items.length;

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}