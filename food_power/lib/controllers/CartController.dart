import 'package:firebase_auth/firebase_auth.dart';
import '../database/database_helper.dart';
import '../models/item.dart'; // Update the path as necessary

class CartController {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final List<void Function()> _listeners = [];

  Future<void> addToCart(Item item) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await _databaseHelper.addToCart(item.id, userId, 1); // Default to adding one item
    _notifyListeners();
  }

  Future<void> updateQuantity(String catalogId, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await _databaseHelper.updateItemQuantity(catalogId, userId, quantity);
    _notifyListeners();
  }

  Future<void> removeFromCart(String catalogId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await _databaseHelper.removeItemFromCart(catalogId, userId);
    _notifyListeners();
  }

  Future<double> getTotalPrice() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await _databaseHelper.getTotalCartPrice(userId);
  }

  Future<List<Item>> getCartItems() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await _databaseHelper.getCartItems(userId);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }
}