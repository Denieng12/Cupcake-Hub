import 'package:dreamflow/models/cupcake.dart';

class CartItem {
  final Cupcake cupcake;
  int quantidade;

  CartItem({
    required this.cupcake,
    this.quantidade = 1,
  });

  double get precoTotal => cupcake.preco * quantidade;

  Map<String, dynamic> toJson() {
    return {
      'cupcake': cupcake.toJson(),
      'quantidade': quantidade,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cupcake: Cupcake.fromJson(json['cupcake']),
      quantidade: json['quantidade'],
    );
  }
}

class Cart {
  List<CartItem> itens = [];

  Cart({List<CartItem>? itens}) : itens = itens ?? [];

  double get total => itens.fold(0, (sum, item) => sum + item.precoTotal);

  int get itemCount => itens.fold(0, (sum, item) => sum + item.quantidade);

  void adicionarItem(Cupcake cupcake, {int quantidade = 1}) {
    final existingIndex = itens.indexWhere(
        (item) => item.cupcake.id == cupcake.id);

    if (existingIndex >= 0) {
      itens[existingIndex].quantidade += quantidade;
    } else {
      itens.add(CartItem(cupcake: cupcake, quantidade: quantidade));
    }
  }

  void removerItem(String cupcakeId) {
    itens.removeWhere((item) => item.cupcake.id == cupcakeId);
  }

  void atualizarQuantidade(String cupcakeId, int quantidade) {
    final index = itens.indexWhere((item) => item.cupcake.id == cupcakeId);
    if (index >= 0) {
      if (quantidade <= 0) {
        removerItem(cupcakeId);
      } else {
        itens[index].quantidade = quantidade;
      }
    }
  }

  void limpar() {
    itens.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      itens: (json['itens'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}