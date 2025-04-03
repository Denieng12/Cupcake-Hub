import 'package:dreamflow/models/cupcake.dart';


class CupcakeService {
  // Lista de cupcakes para demonstração
  List<Cupcake> get _cupcakes => [
    Cupcake(
      id: 'c1',
      nome: 'Red Velvet',
      descricao: 'Cupcake de baunilha com massa vermelha, cobertura cremosa de cream cheese.',
      preco: 8.99,
      imagem: "https://pixabay.com/get/g1574128d429eb83bc83769a4fab4501f646ed80afa16a1e2656f4db9902cb51f41c4b276a5668c7e82c4510114e0b00c74eac627d0468463d16f230415ec418b_1280.jpg",
      categorias: ['Tradicional', 'Favoritos'],
      ingredientes: ['Farinha', 'Cacau', 'Corante Vermelho', 'Cream Cheese', 'Manteiga', 'Açúcar'],
    ),
    Cupcake(
      id: 'c2',
      nome: 'Chocolate Intenso',
      descricao: 'Cupcake de chocolate meio amargo com ganache e raspas de chocolate.',
      preco: 7.99,
      imagem: "https://pixabay.com/get/gab940e467d749047b6cbbdd9e6019707a695a3641484d724e2fb37bf0a7bc1d41c972ecc2e0b8d664c23eface89f1aad9cecf013b1f1118d6b629e9444eae077_1280.jpg",
      categorias: ['Tradicional', 'Chocolate'],
      ingredientes: ['Farinha', 'Cacau', 'Chocolate Meio Amargo', 'Manteiga', 'Açúcar', 'Ovos'],
    ),
    Cupcake(
      id: 'c3',
      nome: 'Baunilha com Frutas',
      descricao: 'Cupcake de baunilha com cobertura de chantilly e frutas frescas da estação.',
      preco: 9.49,
      imagem: "https://pixabay.com/get/gfab9086a7d05ca94a5906eea4e55b5540ca8b5e90ad29a8bf8da9801a0e6116d35c3ea86eb885dad20c83ea0683b992117dfd34339d58098ce64d349b1edd595_1280.jpg",
      categorias: ['Especial', 'Frutas'],
      ingredientes: ['Farinha', 'Essência de Baunilha', 'Manteiga', 'Açúcar', 'Chantilly', 'Frutas Variadas'],
    ),
    Cupcake(
      id: 'c4',
      nome: 'Limão Siciliano',
      descricao: 'Cupcake cítrico com cobertura de merengue italiano e raspas de limão.',
      preco: 8.49,
      imagem: "https://pixabay.com/get/g103625751d7d096e443c85a8abcb0204503a70991b1b02e0daaa5bc0f465645f04dfcbf7784eb3bfa3c0f0a42201194345fc40f378b46cbd4d1f63823b71923c_1280.jpg",
      categorias: ['Especial', 'Cítricos'],
      ingredientes: ['Farinha', 'Suco de Limão', 'Raspas de Limão', 'Manteiga', 'Açúcar', 'Claras'],
    ),
    Cupcake(
      id: 'c5',
      nome: 'Pistache',
      descricao: 'Cupcake aromático de pistache com cobertura de pistache moído.',
      preco: 10.99,
      imagem: "https://pixabay.com/get/g7ee80ddea5f91629fef090ffe80d389afcf0f2fcdc7e0323fc0e187a6af1f563dbbad4cdb226f2b6c79e5196d2cd2f8068518fa214fd271c8a389277a15c7995_1280.jpg",
      categorias: ['Premium', 'Nozes'],
      ingredientes: ['Farinha', 'Pasta de Pistache', 'Manteiga', 'Açúcar', 'Pistache Moído'],
    ),
    Cupcake(
      id: 'c6',
      nome: 'Banoffee',
      descricao: 'Cupcake inspirado na torta inglesa, com banana, doce de leite e chantilly.',
      preco: 9.99,
      imagem: "https://images.unsplash.com/photo-1615560725129-a1fa6edc3b93?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NDM2NDM3OTB8&ixlib=rb-4.0.3&q=80&w=1080",
      categorias: ['Especial', 'Frutas'],
      ingredientes: ['Farinha', 'Banana', 'Doce de Leite', 'Chantilly', 'Manteiga', 'Açúcar'],
    ),
    Cupcake(
      id: 'c7',
      nome: 'Cenoura com Chocolate',
      descricao: 'Cupcake de cenoura com cobertura generosa de ganache de chocolate.',
      preco: 7.99,
      imagem: "https://pixabay.com/get/ge9a2e3dfde6c81029b0dc6ff15b497c478dae8d58484b680a109280b16b990060235e40900ac68c88bdce476fe08df539645b0d1193ecfb47be53df1bd449a97_1280.jpg",
      categorias: ['Tradicional', 'Chocolate'],
      ingredientes: ['Farinha', 'Cenoura', 'Chocolate', 'Manteiga', 'Açúcar', 'Ovos'],
    ),
    Cupcake(
      id: 'c8',
      nome: 'Salgado de Parmesão',
      descricao: 'Cupcake salgado com massa de parmesão e cobertura de cream cheese temperado.',
      preco: 8.49,
      imagem: "https://pixabay.com/get/gf5c6086f500382edeeaa6fc0ec00a974a8fd3fdc7f3ffd54a40892e2900951995a9b49a927293af461e7d03d784e366422ea43069e80a8edd29931d72fbd10e9_1280.jpg",
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