

import '../modal/productModel.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService {
  // Static list jethi aakhi app ma data same rahe
  static final List<CartItem> _cartItems = [];

  // 1. Get Cart Items
  static List<CartItem> getItems() {
    return _cartItems;
  }

  // 2. Add Item
  static void addItem(Product product, int quantity) {
    // Jo item pehla thi cart ma hoi to khali quantity vadharo
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }

  // 3. Remove Item
  static void removeItem(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  // 4. Update Quantity (Optional)
  static void updateQuantity(int productId, int change) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cartItems[index].quantity += change;
      if (_cartItems[index].quantity <= 0) {
        removeItem(productId);
      }
    }
  }
}