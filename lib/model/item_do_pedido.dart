import 'dart:convert';

import 'package:desenvolvimentomobile/model/produto.dart';

class ItemDoPedido {
  int quantidade;
  Produto produto;

  ItemDoPedido(this.quantidade, this.produto);
  ItemDoPedido.novo(this.quantidade, this.produto);

  Map<String, dynamic> toMap() {
    return {
      'quantidade': quantidade,
      'produto': produto.toMap()
    };
  }

  static ItemDoPedido fromMap(Map<String, dynamic> map) {
    return ItemDoPedido(
      map['quantidade'],
      Produto.fromMap(map['produto'])
    );
  }

  static List<ItemDoPedido> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return ItemDoPedido.fromMap(maps[i]);
    });
  }

  static ItemDoPedido fromJson(String j) => ItemDoPedido.fromMap(jsonDecode(j));
  static List<ItemDoPedido> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<ItemDoPedido>((map) => ItemDoPedido.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}
