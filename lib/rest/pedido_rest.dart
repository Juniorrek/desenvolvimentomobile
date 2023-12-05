import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/rest/api.dart';
import 'package:http/http.dart' as http;

class PedidoRest {
  Future<List<Pedido>> listarTodos() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "pedidos/"));
    if (response.statusCode == 200) {
      return Pedido.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os pedidos.');
    }
  }

  Future<List<Pedido>> listarPorCpf(String cpf) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "pedidos/$cpf"));
    if (response.statusCode == 200) {
      return Pedido.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os pedidos.');
    }
  }

  Future<List<Pedido>> listarPorIdProduto(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "pedidos/produto/$id"));
    if (response.statusCode == 200) {
      return Pedido.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os pedidos.');
    }
  }

  Future<Pedido> inserir(Pedido pedido) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'pedidos/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: pedido.toJson());
    if (response.statusCode == 200) {
      return Pedido.fromJson(response.body);
    } else {
      throw Exception('Erro inserindo pedido.');
    }
  }
}
