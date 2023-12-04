import 'package:desenvolvimentomobile/model/produto.dart';

class ItemDoPedido {
  int quantidade;
  Produto produto;

  ItemDoPedido(this.quantidade, this.produto);
  ItemDoPedido.novo(this.quantidade, this.produto);
}