import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/rest/pedido_rest.dart';

class PedidoRepository {
  final PedidoRest api = PedidoRest();
  Future<List<Pedido>> listarTodos() async {
    return await api.listarTodos();
  }

  Future<List<Pedido>> listarPorCpf(String cpf) async {
    return await api.listarPorCpf(cpf);
  }

  Future<List<Pedido>> listarPorIdProduto(int id) async {
    return await api.listarPorIdProduto(id);
  }

  Future<Pedido> inserir(Pedido cliente) async {
    return await api.inserir(cliente);
  }
}
