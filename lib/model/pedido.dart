import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/model/item_do_pedido.dart';

class Pedido {
  int? id;
  DateTime data;
  Cliente cliente;
  List<ItemDoPedido> items;

  Pedido(this.id, this.data, this.cliente, this.items);
  Pedido.novo(this.data, this.cliente, this.items);
}