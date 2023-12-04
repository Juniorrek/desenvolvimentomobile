import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/rest/api.dart';
import 'package:http/http.dart' as http;

class ClienteRest {
  Future<Cliente> buscar(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, '/clientes/$id'));
    if (response.statusCode == 200) {
      return Cliente.fromJson(response.body);
    } else {
      throw Exception(
          'Erro buscando cliente: $id [code: ${response.statusCode}]');
    }
  }

  Future<List<Cliente>> buscarTodos() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "clientes/"));
    if (response.statusCode == 200) {
      return Cliente.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os clientes.');
    }
  }

  Future<Cliente> inserir(Cliente cliente) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'clientes/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: cliente.toJson());
    if (response.statusCode == 200) {
      return Cliente.fromJson(response.body);
    } else {
      throw Exception('Erro inserindo cliente.');
    }
  }

  Future<Cliente> alterar(Cliente cliente) async {
    final http.Response response = await http.put(
      Uri.http(API.endpoint, 'clientes/${cliente.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: cliente.toJson(),
    );
    if (response.statusCode == 200) {
      return cliente;
    } else {
      throw Exception('Erro alterando cliente ${cliente.id}.');
    }
  }

  Future<Cliente> remover(int id) async {
    final http.Response response = await http
        .delete(Uri.http(API.endpoint, '/clientes/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      return Cliente.fromJson(response.body);
    } else {
      throw Exception('Erro removendo cliente: $id.');
    }
  }
}
