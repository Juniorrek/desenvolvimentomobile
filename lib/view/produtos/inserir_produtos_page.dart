import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/produto.dart';
import 'package:desenvolvimentomobile/repositories/produto_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class InserirProdutoPage extends StatefulWidget {
  static const String routeName = '/produtos/inserir';

  const InserirProdutoPage({super.key});
  @override
  _InserirProdutoPageState createState() => _InserirProdutoPageState();
}

class _InserirProdutoPageState extends State<InserirProdutoPage> {
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
          .showSnackBar(const SnackBar(content: Text('Produto salvo com sucesso.')));
      Navigator.pop(context);
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
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Descrição'),
                        controller: _descricaoController,
                        validator: (value) {
                          if (value!.isEmpty) {
                          return 'Campo não pode ser vazio';
                          }
                          return null;
                        },
                      )))
                  
            ]),
            Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton( 
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvar();
                    }
                  },
                  child: const Text('Salvar'),
                ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
                )
              ],
            )
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text("Inserir Produto"),
      ),
      //drawer: const AppDrawer(),
      body: _buildForm(context),
    );
  }
}
