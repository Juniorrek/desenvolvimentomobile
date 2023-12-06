import 'package:desenvolvimentomobile/helper/error.dart';
import 'package:desenvolvimentomobile/model/cliente.dart';
import 'package:desenvolvimentomobile/repositories/cliente_repository.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarClientePage extends StatefulWidget {
  static const String routeName = '/clientes/editar';

  const EditarClientePage({super.key});
  @override
  _EditarClientePageState createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  int _id = 0;
  Cliente? _cliente;
  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _sobrenomeController.dispose();
    super.dispose();
  }

  void _obterCliente() async {
    try {
      var maskFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
      ClienteRepository repository = ClienteRepository();
      this._cliente = await repository.buscar(this._id);
      _cpfController.text = maskFormatter.maskText(this._cliente!.cpf);
      _nomeController.text = this._cliente!.nome;
      _sobrenomeController.text = this._cliente!.sobrenome;
    } catch (exception) {
      showError(context, "Erro recuperando cliente", exception.toString());
      Navigator.pop(context);
    }
  }

  void _salvar() async {
    this._cliente!.cpf = _cpfController.text.replaceAll(RegExp('[^0-9_]+'), '');
    this._cliente!.nome = _nomeController.text;
    this._cliente!.sobrenome = _sobrenomeController.text;
    try {
      ClienteRepository repository = ClienteRepository();
      await repository.alterar(this._cliente!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente editado com sucesso.')));
      Navigator.pop(context);
    } catch (exception) {
      showError(context, "Erro editando cliente", exception.toString());
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
                        controller: _sobrenomeController,
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
                child: Text('Salvar')
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
            ])
          ])) // Form
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Map m = ModalRoute.of(context)!.settings.arguments as Map;
    _id = m["id"];
    _obterCliente();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Cliente"),
      ),
      drawer: const AppDrawer(),
      body: _buildForm(context),
    );
  }
}