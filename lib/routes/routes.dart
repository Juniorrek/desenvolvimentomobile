import 'package:desenvolvimentomobile/main.dart';
import 'package:desenvolvimentomobile/view/clientes/editar_cliente_page.dart';
import 'package:desenvolvimentomobile/view/clientes/inserir_cliente_page.dart';
import 'package:desenvolvimentomobile/view/clientes/listar_clientes_page.dart';
import 'package:desenvolvimentomobile/view/pedidos/inserir_pedido_page.dart';
import 'package:desenvolvimentomobile/view/pedidos/listar_pedidos_page.dart';
import 'package:desenvolvimentomobile/view/produtos/editar_produtos_page.dart';
import 'package:desenvolvimentomobile/view/produtos/inserir_produtos_page.dart';
import 'package:desenvolvimentomobile/view/produtos/listar_produtos_page.dart';

class Routes {
static const String home = MyHomePage.routeName;
static const String clienteList = ListarClientesPage.routeName;
static const String clienteInsert = InserirClientePage.routeName;
static const String clienteEdit = EditarClientePage.routeName;

static const String pedidoList = ListarPedidosPage.routeName;
static const String pedidoInsert = InserirPedidoPage.routeName;

static const String produtoList = ListarProdutosPage.routeName;
static const String produtoInsert = InserirProdutoPage.routeName;
static const String produtoEdit = EditarProdutoPage.routeName;
}