import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/item_do_pedido.dart';
import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/repositories/pedido_repository.dart';
import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListarPedidosPage extends StatefulWidget {
  static const String routeName = '/pedidos';

  const ListarPedidosPage({super.key});
  @override
  State<StatefulWidget> createState() => _ListarPedidosPageState();
}

class _ListarPedidosPageState extends State<ListarPedidosPage> {
  List<Pedido> _lista = <Pedido>[];
  List<ItemDoPedido> _listaItems = <ItemDoPedido>[];
  final _cpfController = TextEditingController();
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
    List<Pedido> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Pedido>> _obterTodos() async {
    List<Pedido> tempLista = <Pedido>[];
    try {
      PedidoRepository repository = PedidoRepository();
      tempLista = await repository.listarTodos();
    } catch (exception) {
      showError(context, "Erro obtendo lista de pedidos", exception.toString());
    }
    return tempLista;
  }

  void _showItem(BuildContext context, int index) {
    Pedido pedido = _lista[index];
    var format = DateFormat("dd/MM/yyyy");

    setState(() {
      _listaItems = pedido.items;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Visualizar Pedido'),
              content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.person),
                        Flexible(
                          child: Text(
                              "Cliente: ${pedido.cliente.nome} ${pedido.cliente.sobrenome}"),
                        ),
                      ]),
                      Row(children: [
                        const Icon(Icons.today),
                        Text("Data: ${format.format(pedido.data)}")
                      ]),
                      const Row(children: [
                        Icon(Icons.category),
                        Text("Items:")
                      ]),
                      Expanded(
                          child: ListView.builder(
                        itemCount: pedido.items.length,
                        itemBuilder: (context, index) => Text(
                            '${pedido.items[index].quantidade}x ${pedido.items[index].produto.descricao}'),
                      ))
                    ],
                  )),
              actions: [
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  ListTile _buildItem(BuildContext context, int index) {
    Pedido b = _lista[index];
    var format = DateFormat("dd/MM/yyyy");

    return ListTile(
      leading: const Icon(Icons.person),
      title: Text('${b.cliente.nome} ${b.cliente.sobrenome}'),
      subtitle: Text(format.format(b.data)),
      onTap: () {
        _showItem(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de Pedidos"),
      ),
      drawer: const AppDrawer(),
      body: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Text("CPF:"),
              Expanded(
                  child: TextFormField(
                controller: _cpfController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [ElevatedButton(
                  onPressed: () {
                    /*if (_formKey.currentState!.validate()) {
                      _salvar();
                    }*/
                  },
                  child: const Icon(Icons.filter_alt),
                )],)
              ],
            ),
        const Divider(),
        Expanded(
            child: Container(
                child: ListView.builder(
        itemCount: _lista.length,
        itemBuilder: _buildItem,
      ),
            )
        )
      ],)
      
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, Routes.clienteInsert),
        child: const Icon(Icons.add),
      ),
    );
  }
}
