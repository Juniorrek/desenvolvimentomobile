import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
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

  void _removerProduto(int id) async {}

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
    /*Produto b = _lista[index];
    Navigator.pushNamed(
    context,
    EditarProdutoPage.routeName,
    arguments: <String, int>{
    "id": b.id!
    },
    );*/
  }

  void _removeItem(BuildContext context, int index) {
    Produto b = _lista[index]; showDialog( context: context,
    builder: (BuildContext context) => AlertDialog( title: Text("Remover Produto"),
    content: Text("Gostaria realmente de remover ${b.descricao}?"), actions: [ TextButton(
    child: Text("Não"), onPressed: () { Navigator.of(context).pop(); }, ),
    TextButton( child: Text("Sim"), onPressed: () {
      _removerProduto(b.id!);
      _refreshList(); 
      Navigator.of(context).pop();
    }, ), ],
    ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    Produto b = _lista[index];

    return ListTile(
      leading: const Icon(Icons.person),
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
          onPressed: () => Navigator.pushReplacementNamed(context, Routes.produtoInsert),
          child: const Icon(Icons.add),
        ),
    );
  }
}
