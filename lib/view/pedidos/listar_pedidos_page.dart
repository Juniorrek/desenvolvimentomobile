import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/item_do_pedido.dart';
import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/repositories/pedido_repository.dart';
import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ListarPedidosPage extends StatefulWidget {
  static const String routeName = '/pedidos';

  const ListarPedidosPage({super.key});
  @override
  State<StatefulWidget> createState() => _ListarPedidosPageState();
}

class _ListarPedidosPageState extends State<ListarPedidosPage> {
  final _formKey = GlobalKey<FormState>();
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

  void _filtrarPedidos() async {
    String cpf = _cpfController.text.replaceAll(RegExp('[^0-9_]+'), '');

    List<Pedido> tempList;
    if (cpf != '') {
      tempList = await _obterFiltrado(cpf);
    } else {
      tempList = await _obterTodos();
    }
    setState(() {
      _lista = tempList;
    });
  }

  void _refreshList() async {
    List<Pedido> tempList = await _obterTodos();
    setState(() {
      _lista = tempList;
    });
  }

  Future<List<Pedido>> _obterFiltrado(String cpf) async {
    List<Pedido> tempLista = <Pedido>[];
    try {
      PedidoRepository repository = PedidoRepository();
      tempLista = await repository.listarPorCpf(cpf);
    } catch (exception) {
      showError(context, "Erro obtendo lista de pedidos", exception.toString());
    }
    return tempLista;
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
                        Text("Data: ${format.format(pedido.data!)}")
                      ]),
                      const Row(
                          children: [Icon(Icons.category), Text("Items:")]),
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
      subtitle: Text(format.format(b.data!)),
      onTap: () {
        _showItem(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text("Listagem de Pedidos"),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Form(
              key: _formKey,
              child: ListView(shrinkWrap: true, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Filtrar por CPF'),
                              controller: _cpfController,
                              validator: (value) {
                                if (value?.length != 0 && value!.length < 14) {
                                  return 'CPF incorreto';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: '###.###.###-##',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.lazy)
                              ])))
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _filtrarPedidos();
                            }
                          },
                          child: const Icon(Icons.filter_alt),
                        )
                      ],
                    )
                  ],
                )
              ])),
          const Divider(),
          Expanded(
              child: Container(
            child: ListView.builder(
              itemCount: _lista.length,
              itemBuilder: _buildItem,
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.pedidoInsert)
            .then((value) => _refreshList()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
