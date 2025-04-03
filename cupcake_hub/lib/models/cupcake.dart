class Cupcake {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;
  final List<String> categorias;
  final List<String> ingredientes;
  final bool disponivel;

  Cupcake({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
    required this.categorias,
    required this.ingredientes,
    this.disponivel = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem,
      'categorias': categorias,
      'ingredientes': ingredientes,
      'disponivel': disponivel,
    };
  }

  factory Cupcake.fromJson(Map<String, dynamic> json) {
    return Cupcake(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      imagem: json['imagem'],
      categorias: List<String>.from(json['categorias']),
      ingredientes: List<String>.from(json['ingredientes']),
      disponivel: json['disponivel'] ?? true,
    );
  }
}