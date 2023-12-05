import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/repositories/cliente_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

class InserirClientePage extends StatefulWidget {
  static const String routeName = '/clientes/insert';
  @override
  _InserirClienteState createState() => _InserirClienteState();
}

class _InserirClienteState extends State<InserirClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeControler = TextEditingController();

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _sobrenomeControler.dispose();
    super.dispose();
  }

  void _salvar() async {
    Cliente cliente = Cliente.novo(_cpfController.text, _nomeController.text, _sobrenomeControler.text);
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.inserir(cliente);
      _cpfController.clear();
      _nomeController.clear();
      _sobrenomeControler.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cliente salvo com sucesso.')));
    } catch (exception) {
      showError(context, "Erro inserindo cliente", exception.toString());
    }
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("CPF:"),
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
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Nome:"),
              Expanded(
                  child: TextFormField(
                controller: _nomeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("Sobrenome:"),
              Expanded(
                  child: TextFormField(
                controller: _sobrenomeControler,
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
        title: Text("Inserir Cliente"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}
