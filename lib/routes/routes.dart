import 'package:desenvolvimentomobile/main.dart';
import 'package:desenvolvimentomobile/view/editar_cliente_page.dart';
import 'package:desenvolvimentomobile/view/inserir_cliente_page.dart';
import 'package:desenvolvimentomobile/view/inserir_pedido_page.dart';
import 'package:desenvolvimentomobile/view/listar_clientes_page.dart';
import 'package:desenvolvimentomobile/view/listar_pedidos_page.dart';

class Routes {
static const String home = MyHomePage.routeName;
static const String clienteList = ListarClientesPage.routeName;
static const String clienteInsert = InserirClientePage.routeName;
static const String clienteEdit = EditarClientePage.routeName;

static const String pedidoList = ListarPedidosPage.routeName;
static const String pedidoInsert = InserirPedidoPage.routeName;
}