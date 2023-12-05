import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/repositories/cliente_repository.dart';
import 'package:desenvolvimentomobile/repositories/pedido_repository.dart';
import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class ListarClientesPage extends StatefulWidget {
  static const String routeName = '/list';

  const ListarClientesPage({super.key});
  @override
  State<StatefulWidget> createState() => _ListarClientesPageState();
}

class _ListarClientesPageState extends State<ListarClientesPage> {
  List<Cliente> _lista = <Cliente>[];
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
    List<Cliente> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Cliente>> _obterTodos() async {
    List<Cliente> tempLista = <Cliente>[];
    try {
      ClienteRepository repository = ClienteRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de clientes", exception.toString());
    }
    return tempLista;
  }

  void _removerCliente(Cliente cliente) async {
    try {
      PedidoRepository pedidoRepository = PedidoRepository();
      List<Pedido> pedidos = await pedidoRepository.listarPorCpf(cliente.cpf);

      if (pedidos.length > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não é possível excluir esse cliente pois ele tem pedidos.')));
      } else {
        ClienteRepository repository = ClienteRepository();
        await repository.remover(cliente.id!).then((value) {
          _refreshList();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliente ${cliente.id} removido com sucesso.')));
        });
      }
    } catch (exception) {
      showError(context, "Erro removendo cliente", exception.toString());
    }
  }

  void _showItem(BuildContext context, int index) {
    Cliente cliente = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(cliente.nome),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.fingerprint),
                    Text("CPF: ${cliente.cpf}")
                  ]),
                  Row(children: [
                    const Icon(Icons.person),
                    Text("Nome: ${cliente.nome}")
                  ]),
                  Row(children: [
                    const Icon(Icons.badge),
                    Text("Sobrenome: ${cliente.sobrenome}")
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
    /*Cliente b = _lista[index];
    Navigator.pushNamed(
    context,
    EditarClientePage.routeName,
    arguments: <String, int>{
    "id": b.id!
    },
    );*/
  }

  void _removeItem(BuildContext context, int index) {
    Cliente b = _lista[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Remover Cliente"),
              content: Text("Gostaria realmente de remover ${b.nome}?"),
              actions: [
                TextButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    _removerCliente(b);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    Cliente b = _lista[index];

    return ListTile(
      leading: const Icon(Icons.person),
      title: Text('${b.nome} ${b.sobrenome}'),
      subtitle: Text(b.cpf),
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
          title: const Text("Listagem de Clientes"),
        ),
        drawer: const AppDrawer(),
        body: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: _buildItem,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, Routes.clienteInsert).then((value) => _refreshList()),
          child: const Icon(Icons.add),
        ),
    );
  }
}
