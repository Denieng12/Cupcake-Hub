import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dreamflow/models/cart.dart';
import 'package:dreamflow/models/cupcake.dart';

class CartProvider with ChangeNotifier {
  Cart _cart = Cart();
  final String _cartStorageKey = 'cart_data';

  CartProvider() {
    _loadCartFromStorage();
  }

  Cart get cart => _cart;
  List<CartItem> get items => _cart.itens;
  double get total => _cart.total;
  int get itemCount => _cart.itemCount;

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartStorageKey);

      if (cartJson != null) {
        final cartData = jsonDecode(cartJson);
        _cart = Cart.fromJson(cartData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar carrinho: $e');
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(_cart.toJson());
      await prefs.setString(_cartStorageKey, cartJson);
    } catch (e) {
      debugPrint('Erro ao salvar carrinho: $e');
    }
  }

  void adicionarItem(Cupcake cupcake, {int quantidade = 1}) {
    _cart.adicionarItem(cupcake, quantidade: quantidade);
    _saveCartToStorage();
    notifyListeners();
  }

  void removerItem(String cupcakeId) {
    _cart.removerItem(cupcakeId);
    _saveCartToStorage();
    notifyListeners();
  }

  void atualizarQuantidade(String cupcakeId, int quantidade) {
    _cart.atualizarQuantidade(cupcakeId, quantidade);
    _saveCartToStorage();
    notifyListeners();
  }

  void limparCarrinho() {
    _cart.limpar();
    _saveCartToStorage();
    notifyListeners();
  }
}