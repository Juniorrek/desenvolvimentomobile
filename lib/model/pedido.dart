import 'dart:convert';

import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/model/item_do_pedido.dart';

class Pedido {
  int? id;
  DateTime? data;
  Cliente cliente;
  List<ItemDoPedido> items;

  Pedido(this.id, this.data, this.cliente, this.items);
  Pedido.novo(this.cliente, this.items);

  static DateTime dateTimeFromTimestamp(int date) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic>? c = this.cliente != null ? this.cliente.toMap() : null;

    List<Map<String, dynamic>>? i =
        this.items != null ? this.items.map((i) => i.toMap()).toList() : null;

    return {
      'id': id,
      'data': data,
      'cliente': c,
      'items': i
    };
  }

  static Pedido fromMap(Map<String, dynamic> map) {
    return Pedido(
      map['id'],
      dateTimeFromTimestamp(map['data']),
      Cliente.fromMap(map['cliente']),
      ItemDoPedido.fromMaps(List<Map<String, dynamic>>.from(map['items']))
    );
  }

  static List<Pedido> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Pedido.fromMap(maps[i]);
    });
  }

  static Pedido fromJson(String j) => Pedido.fromMap(jsonDecode(j));
  static List<Pedido> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Pedido>((map) => Pedido.fromMap(map)).toList();
  }

  String toJson() => jsonEncode(toMap());
}