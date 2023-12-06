import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/rest/api.dart';
import 'package:http/http.dart' as http;

class ProdutoRest {
  Future<Produto> buscar(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, '/produtos/$id'));
    if (response.statusCode == 200) {
      return Produto.fromJson(response.body);
    } else {
      throw Exception(
          'Erro buscando cliente: $id [code: ${response.statusCode}]');
    }
  }

  Future<List<Produto>> buscarTodos() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "produtos/"));
    if (response.statusCode == 200) {
      return Produto.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os produtos.');
    }
  }

  Future<Produto> inserir(Produto produto) async {
    final http.Response response =
      await http.post(
        Uri.http(API.endpoint, 'produtos/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: produto.toJson());
    if (response.statusCode == 200) {
      return produto ;//Produto.fromJson(response.body);
    } else {
      throw Exception('Erro inserindo cliente.');
    }
  }

  Future<Produto> alterar(Produto produto) async {
    final http.Response response = 
      await http.put(
        Uri.http(API.endpoint, 'produtos/${produto.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: produto.toJson(),
    );
    if (response.statusCode == 200) {
      return produto;
    } else {
      throw Exception('Erro alterando cliente ${produto.id}.');
    }
  }

  Future<Produto> remover(int id) async {
    final http.Response response = await http
        .delete(Uri.http(API.endpoint, '/produtos/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      return Produto.fromJson(response.body);
    } else {
      throw Exception('Erro removendo cliente: $id.');
    }
  }
}
