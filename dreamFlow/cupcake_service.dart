import 'package:dreamflow/models/cupcake.dart';

class CupcakeService {
  // Lista de cupcakes para demonstração
  final List<Cupcake> _cupcakes = [
    Cupcake(
      id: 'c1',
      nome: 'Red Velvet',
      descricao: 'Cupcake de baunilha com massa vermelha, cobertura cremosa de cream cheese.',
      preco: 8.99,
      imagem: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7',
      categorias: ['Tradicional', 'Favoritos'],
      ingredientes: ['Farinha', 'Cacau', 'Corante Vermelho', 'Cream Cheese', 'Manteiga', 'Açúcar'],
    ),
    Cupcake(
      id: 'c2',
      nome: 'Chocolate Intenso',
      descricao: 'Cupcake de chocolate meio amargo com ganache e raspas de chocolate.',
      preco: 7.99,
      imagem: 'https://images.unsplash.com/photo-1587668178277-295251f900ce',
      categorias: ['Tradicional', 'Chocolate'],
      ingredientes: ['Farinha', 'Cacau', 'Chocolate Meio Amargo', 'Manteiga', 'Açúcar', 'Ovos'],
    ),
    Cupcake(
      id: 'c3',
      nome: 'Baunilha com Frutas',
      descricao: 'Cupcake de baunilha com cobertura de chantilly e frutas frescas da estação.',
      preco: 9.49,
      imagem: 'https://images.unsplash.com/photo-1519869325930-281384150729',
      categorias: ['Especial', 'Frutas'],
      ingredientes: ['Farinha', 'Essência de Baunilha', 'Manteiga', 'Açúcar', 'Chantilly', 'Frutas Variadas'],
    ),
    Cupcake(
      id: 'c4',
      nome: 'Limão Siciliano',
      descricao: 'Cupcake cítrico com cobertura de merengue italiano e raspas de limão.',
      preco: 8.49,
      imagem: 'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd',
      categorias: ['Especial', 'Cítricos'],
      ingredientes: ['Farinha', 'Suco de Limão', 'Raspas de Limão', 'Manteiga', 'Açúcar', 'Claras'],
    ),
    Cupcake(
      id: 'c5',
      nome: 'Pistache',
      descricao: 'Cupcake aromático de pistache com cobertura de pistache moído.',
      preco: 10.99,
      imagem: 'https://images.unsplash.com/photo-1603532648955-039310d9ed75',
      categorias: ['Premium', 'Nozes'],
      ingredientes: ['Farinha', 'Pasta de Pistache', 'Manteiga', 'Açúcar', 'Pistache Moído'],
    ),
    Cupcake(
      id: 'c6',
      nome: 'Banoffee',
      descricao: 'Cupcake inspirado na torta inglesa, com banana, doce de leite e chantilly.',
      preco: 9.99,
      imagem: 'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b',
      categorias: ['Especial', 'Frutas'],
      ingredientes: ['Farinha', 'Banana', 'Doce de Leite', 'Chantilly', 'Manteiga', 'Açúcar'],
    ),
    Cupcake(
      id: 'c7',
      nome: 'Cenoura com Chocolate',
      descricao: 'Cupcake de cenoura com cobertura generosa de ganache de chocolate.',
      preco: 7.99,
      imagem: 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb',
      categorias: ['Tradicional', 'Chocolate'],
      ingredientes: ['Farinha', 'Cenoura', 'Chocolate', 'Manteiga', 'Açúcar', 'Ovos'],
    ),
    Cupcake(
      id: 'c8',
      nome: 'Salgado de Parmesão',
      descricao: 'Cupcake salgado com massa de parmesão e cobertura de cream cheese temperado.',
      preco: 8.49,
      imagem: 'https://images.unsplash.com/photo-1576618148194-cbc4e5f84b3e',
      categorias: ['Salgado', 'Novidades'],
      ingredientes: ['Farinha', 'Queijo Parmesão', 'Cream Cheese', 'Manteiga', 'Sal', 'Especiarias'],
    ),
  ];

  // Obter todos os cupcakes
  List<Cupcake> getAll() {
    return [..._cupcakes];
  }

  // Obter um cupcake pelo ID
  Cupcake? getById(String id) {
    try {
      return _cupcakes.firstWhere((cupcake) => cupcake.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter cupcakes por categoria
  List<Cupcake> getByCategory(String category) {
    return _cupcakes.where((cupcake) => 
      cupcake.categorias.contains(category)).toList();
  }

  // Pesquisar cupcakes por nome ou descrição
  List<Cupcake> search(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _cupcakes.where((cupcake) {
      return cupcake.nome.toLowerCase().contains(lowercaseQuery) ||
             cupcake.descricao.toLowerCase().contains(lowercaseQuery) ||
             cupcake.ingredientes.any((ingrediente) => 
                 ingrediente.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Obter categorias disponíveis
  List<String> getCategories() {
    final Set<String> categories = {};
    for (var cupcake in _cupcakes) {
      categories.addAll(cupcake.categorias);
    }
    return categories.toList()..sort();
  }
}