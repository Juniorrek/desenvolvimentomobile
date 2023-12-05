import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/model/item_do_pedido.dart';
import 'package:desenvolvimentomobile/model/pedido.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/repositories/cliente_repository.dart';
import 'package:desenvolvimentomobile/repositories/pedido_repository.dart';
import 'package:desenvolvimentomobile/repositories/produto_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InserirPedidoPage extends StatefulWidget {
  static const String routeName = '/pedidos/inserir';

  const InserirPedidoPage({super.key});
  @override
  _InserirPedidoState createState() => _InserirPedidoState();
}

class _InserirPedidoState extends State<InserirPedidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  List<Produto> produtos = [];
  Produto? _produtoSelecionado;
  List<ItemDoPedido> itemsCarrinho = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  void _refreshList() async {
    List<Produto> tempList = await _buscarProdutos();
    setState(() {
      produtos = tempList;
    });
  }

  Future<List<Produto>> _buscarProdutos() async {
    List<Produto> tempLista = <Produto>[];
    try {
      ProdutoRepository repository = ProdutoRepository();
      tempLista = await repository.buscarTodos();
    } catch (exception) {
      showError(
          context, "Erro obtendo lista de produtos", exception.toString());
    }
    return tempLista;
  }

  void insereProduto() {
    if (itemsCarrinho.any((p) => p.produto.id == _produtoSelecionado?.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto já adicionado no carrinho')));
    } else if (_produtoSelecionado == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecione um produto')));
    } else {
      var novoItem = ItemDoPedido(1, _produtoSelecionado!);
      setState(() {
        itemsCarrinho.add(novoItem);
      });
    }
  }

  void _salvar() async {
    if (itemsCarrinho.isNotEmpty) {
      if (itemsCarrinho.any((e) => e.quantidade <= 0)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Quantidade deve ser maior que 0')));
      } else {
        try {
          ClienteRepository clienteRepository = ClienteRepository();
          Cliente? cliente = await clienteRepository.buscarPorCpf(_cpfController.text.replaceAll(RegExp('[^0-9_]+'), ''));

          if (cliente != null) {
            PedidoRepository pedidoRepository = PedidoRepository();
            Pedido pedido = Pedido.novo(cliente, itemsCarrinho);

            await pedidoRepository.inserir(pedido);
            _cpfController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido salvo com sucesso.')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Cliente não encontrado')));
          }
        } catch (exception) {
          showError(context, "Erro inserindo pedido", exception.toString());
        }
      }

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Adicione pelo menos 1 produto')));
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
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
                              labelText: 'CPF do Cliente'),
                          controller: _cpfController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo não pode ser vazio';
                            }
                            if (value.length < 14) {
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
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButtonFormField<Produto>(
                              value: _produtoSelecionado,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              hint: const Text(
                                ' Selecione um produto ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              isExpanded: true,
                              items: produtos.map((Produto produto) {
                                return DropdownMenuItem<Produto>(
                                    value: produto,
                                    child: Text(produto.descricao));
                              }).toList(),
                              onChanged: (Produto? value) {
                                setState(() {
                                  _produtoSelecionado = value!;
                                });
                              })))),
              ElevatedButton(
                onPressed: insereProduto,
                child: const Icon(Icons.add),
              )
            ]),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Carrinho',
                  style: TextStyle(fontSize: 24),
                )),
            DataTable(
                columns: const [
                  DataColumn(label: Text('Produto')),
                  DataColumn(label: Text('Quantidade'))
                ],
                rows: itemsCarrinho
                    .map<DataRow>((e) => DataRow(cells: [
                          DataCell(Text(e.produto.descricao)),
                          DataCell(SpinBox(
                              min: 1, max: 100, value: e.quantidade.toDouble(),
                              onChanged: (value) => e.quantidade = value.toInt()))
                        ]))
                    .toList()),
                    const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvar();
                    }
                  },
                  child: const Text('Fazer Pedido'),
                )
              ],
            )
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: const Text("Inserir Pedido"),
        ),
        drawer: const AppDrawer(),
        body: _buildForm(context));
  }
}
