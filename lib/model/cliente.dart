import 'dart:convert';

class Cliente {
  int? id;
  String cpf;
  String nome;
  String sobrenome;

  Cliente(this.id, this.cpf, this.nome, this.sobrenome);
  Cliente.novo(this.cpf, this.nome, this.sobrenome);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome
    };
  }

  static Cliente fromMap(Map<String, dynamic> map) {
    return Cliente(
      map['id'],
      map['cpf'],
      map['nome'],
      map['sobrenome'],
    );
  }

  static List<Cliente> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Cliente.fromMap(maps[i]);
    });
  }

  static Cliente fromJson(String j) => Cliente.fromMap(jsonDecode(j));
  static List<Cliente> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Cliente>((map) => Cliente.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}
