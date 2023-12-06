import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/repositories/cliente_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InserirClientePage extends StatefulWidget {
  static const String routeName = '/clientes/inserir';

  const InserirClientePage({super.key});
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
    Cliente cliente = Cliente.novo(
        _cpfController.text.replaceAll(RegExp('[^0-9_]+'), ''),
        _nomeController.text,
        _sobrenomeControler.text);
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.inserir(cliente);
      _cpfController.clear();
      _nomeController.clear();
      _sobrenomeControler.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente salvo com sucesso.')));
      Navigator.pop(context);
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
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'CPF'),
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
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Nome'),
                        controller: _nomeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo não pode ser vazio';
                          }
                          return null;
                        },
                      )))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Sobrenome'),
                        controller: _sobrenomeControler,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo não pode ser vazio';
                          }
                          return null;
                        },
                      )))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvar();
                    }
                  },
                  child: const Text('Salvar')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ])
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inserir Cliente"),
      ),
      drawer: const AppDrawer(),
      body: _buildForm(context),
    );
  }
}
