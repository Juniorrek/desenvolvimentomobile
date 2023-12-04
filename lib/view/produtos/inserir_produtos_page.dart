import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/repositories/produto_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class InserirProdutoPage extends StatefulWidget {
  static const String routeName = '/insert';
  @override
  _InserirProdutoState createState() => _InserirProdutoState();
}

class _InserirProdutoState extends State<InserirProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    Produto produto = Produto.novo(_descricaoController.text);
    try {
      ProdutoRepository repository = ProdutoRepository();
      await repository.inserir(produto);
      _descricaoController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Produto salvo com sucesso.')));
    } catch (exception) {
      showError(context, "Erro inserindo produto", exception.toString());
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Descrição: "),
              Expanded(
                  child: TextFormField(
                controller: _descricaoController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
         
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvar();
                    }
                  },
                  child: Text('Salvar'),
                )
              ],
            )
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Inserir Produto"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}
