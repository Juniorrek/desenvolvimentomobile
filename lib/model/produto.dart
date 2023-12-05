import 'dart:convert';

class Produto {
  int? id;
  String descricao;

  Produto(this.id, this.descricao);
  Produto.novo(this.descricao);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      map['id'],
      map['descricao']
    );
  }

  static List<Produto> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }

  static Produto fromJson(String j) => Produto.fromMap(jsonDecode(j));
  static List<Produto> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Produto>((map) => Produto.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}