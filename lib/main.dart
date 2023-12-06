import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:desenvolvimentomobile/view/clientes/editar_cliente_page.dart';
import 'package:desenvolvimentomobile/view/clientes/inserir_cliente_page.dart';
import 'package:desenvolvimentomobile/view/clientes/listar_clientes_page.dart';
import 'package:desenvolvimentomobile/view/pedidos/inserir_pedido_page.dart';
import 'package:desenvolvimentomobile/view/pedidos/listar_pedidos_page.dart';
import 'package:desenvolvimentomobile/view/produtos/editar_produtos_page.dart';
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
        Routes.clienteInsert: (context) => const InserirClientePage(),
        Routes.clienteEdit: (context) => const EditarClientePage(),
        Routes.pedidoList: (context) => const ListarPedidosPage(),
        Routes.pedidoInsert: (context) => const InserirPedidoPage(),     
        Routes.produtoList: (context) => const ListarProdutosPage(),
        Routes.produtoInsert: (context) => const InserirProdutoPage(),
        Routes.produtoEdit: (context) => const EditarProdutoPage()

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
      body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Text('Loja dos Alunos', style: TextStyle(fontSize: 48) ),
        Divider(),
        Text('David Reksidler Júnior', style: TextStyle(fontSize: 20)),
        Text('Mateus Lodi', style: TextStyle(fontSize: 20)),
        Text('Matheus Schelbauer', style: TextStyle(fontSize: 20)),
        Text('Renata Soares', style: TextStyle(fontSize: 20))])
      ),
      drawer: const AppDrawer(),
    );
  }
}
