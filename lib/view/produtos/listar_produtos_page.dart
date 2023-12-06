import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/repositories/pedido_repository.dart';
import 'package:desenvolvimentomobile/repositories/produto_repository.dart';
import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class ListarProdutosPage extends StatefulWidget {
  static const String routeName = '/produtos/list';

  const ListarProdutosPage({super.key});
  @override
  State<StatefulWidget> createState() => _ListarProdutosPageState();
}

class _ListarProdutosPageState extends State<ListarProdutosPage> {
  List<Produto> _lista = <Produto>[];
  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshList() async {
    List<Produto> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Produto>> _obterTodos() async {
    List<Produto> tempLista = <Produto>[];
    try {
      ProdutoRepository repository = ProdutoRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de Produtos", exception.toString());
    }
    return tempLista;
  }

  void _removerProduto(Produto produto) async {
    try {
      PedidoRepository pedidoRepository = PedidoRepository();
      List<Pedido> pedidos =
          await pedidoRepository.listarPorIdProduto(produto.id!);

      if (pedidos.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Não é possível excluir pois esse produto esta vinculado a pedidos.')));
      } else {
        ProdutoRepository repository = ProdutoRepository();
        await repository.remover(produto.id!).then((value) {
          _refreshList();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Produto ${produto.id} removido com sucesso.')));
        });
      }
    } catch (exception) {
      showError(context, "Erro removendo produto", exception.toString());
    }
  }

  void _showItem(BuildContext context, int index) {
    Produto produto = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(produto.descricao),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.create),
                    Text("Descrição: ${produto.descricao}")
                  ]),
                ],
              ),
              actions: [
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _editItem(BuildContext context, int index) {
    Produto b = _lista[index];
    Navigator.pushNamed(context, Routes.produtoEdit,
        arguments: <String, int>{"id": b.id!}).then((value) => _refreshList());
  }

  void _removeItem(BuildContext context, int index) {
    Produto b = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Remover Produto"),
              content: Text("Gostaria realmente de remover ${b.descricao}?"),
              actions: [
                TextButton(
                  child: const Text("Não"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Sim"),
                  onPressed: () {
                    _removerProduto(b);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    Produto b = _lista[index];

    return ListTile(
      leading: const Icon(
          Icons.propane), //TODO trocar esse icon pelo de produtos kkkk
      title: Text('${b.id} '),
      subtitle: Text(b.descricao),
      onTap: () {
        _showItem(context, index);
      },
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            const PopupMenuItem(value: 'delete', child: Text('Remover'))
          ];
        },
        onSelected: (String value) {
          if (value == 'edit') {
            _editItem(context, index);
          } else {
            _removeItem(context, index);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de Produtos"),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: _lista.length,
        itemBuilder: _buildItem,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, Routes.produtoInsert),
        child: const Icon(Icons.add),
      ),
    );
  }
}
