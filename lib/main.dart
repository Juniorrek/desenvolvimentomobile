import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/view/clientes/inserir_cliente_page.dart';
import 'package:desenvolvimentomobile/view/clientes/listar_clientes_page.dart';
import 'package:desenvolvimentomobile/view/produtos/inserir_produtos_page.dart';
import 'package:desenvolvimentomobile/view/produtos/listar_produtos_page.dart';
import 'package:desenvolvimentomobile/widgets/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desenvolvimento Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
      routes: {
        Routes.home: (context) => const MyHomePage(title: 'Home'),
        Routes.clienteList: (context) => const ListarClientesPage(),
        Routes.clienteInsert: (context) => InserirClientePage(),        
        Routes.produtoList: (context) => const ListarProdutosPage(),
        Routes.produtoInsert: (context) => InserirProdutoPage(),
        /*Routes.cliente_edit: (context) => EditarClientePage(),
        Routes.cliente_insert: (context) => InserirClientePage(),*/

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static const String routeName = '/home';

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
    );
  }
}
