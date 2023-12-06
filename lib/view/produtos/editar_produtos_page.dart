import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/repositories/produto_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class EditarProdutoPage extends StatefulWidget {
  static const String routeName = '/produtos/editar';

  const EditarProdutoPage({super.key});
  @override
  _EditarProdutoPageState createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricao = TextEditingController();
  int _id = 0;
  Produto? _produto;
  @override
  void dispose() {
    _descricao.dispose();
    super.dispose();
  }

  void _obterProduto() async {
    try {
      ProdutoRepository repository = ProdutoRepository();
      _produto = await repository.buscar(_id);
      _descricao.text = _produto!.descricao;
    } catch (exception) {
      showError(context, "Erro recuperando produto", exception.toString());
      Navigator.pop(context);
    }
  }

  void _salvar() async {
    _produto!.descricao = _descricao.text;
    try {
      ProdutoRepository repository = ProdutoRepository();
      await repository.alterar(_produto!);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto editado com sucesso.')));
      Navigator.pop(context);
    } catch (exception) {
      showError(context, "Erro editando produto", exception.toString());
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
                            border: OutlineInputBorder(), labelText: 'Descrição'),
                        controller: _descricao,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo não pode ser vazio';
                          }
                          return null;
                        },
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, 
              children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _salvar();
                  }
                },
                child: const Text('Salvar')
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ])
          ])) // Form
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Map m = ModalRoute.of(context)!.settings.arguments as Map;
    _id = m["id"];
    _obterProduto();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Produto"),
      ),
      drawer: const AppDrawer(),
      body: _buildForm(context),
    );
  }
}
