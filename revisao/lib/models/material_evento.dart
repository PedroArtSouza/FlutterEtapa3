// Representa uma linha da tabela materiais.
class MaterialEvento {
  final int? id;
  final String nome;
  final String categoria;
  final int quantidade;
  final int minimo;

  const MaterialEvento({
    this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    required this.minimo,
  });

  // A mesma normalização deve ser usada no cadastro e na consulta de duplicidade.
  String get nomeNormalizado => nome.trim().toLowerCase();

  String get situacao {
    if (quantidade == 0) return 'Sem estoque';
    if (quantidade < minimo) return 'Estoque baixo';
    return 'Estoque adequado';
  }

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'nome': nome.trim(),
    'nome_normalizado': nomeNormalizado,
    'categoria': categoria.trim(),
    'quantidade': quantidade,
    'minimo': minimo,
  };

  factory MaterialEvento.fromMap(Map<String, Object?> map) => MaterialEvento(
    id: map['id'] as int,
    nome: map['nome'] as String,
    categoria: map['categoria'] as String,
    quantidade: (map['quantidade'] as num).toInt(),
    minimo: (map['minimo'] as num).toInt(),
  );
}
