import 'package:desenvolvimentomobile/routes/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _createHeader() {
    return const DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/shrek.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Desenvolvimento Mobile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _createHeader(),
        _createDrawerItem(
            icon: Icons.store,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              //Navigator.pushReplacementNamed(context, Routes.home);
            }),
        _createDrawerItem(
            icon: Icons.groups,
            text: 'Clientes',
            onTap: () {
              Navigator.pop(context);//Drawer
              if (Navigator.canPop(context)) {
                Navigator.pop(context);//Retira pagina atual da pilha
              }
              Navigator.pushNamed(context, Routes.clienteList);
            }),
        _createDrawerItem(
            icon: Icons.sell,
            text: 'Produtos',
            onTap: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushNamed(context, Routes.produtoList);
            }),
        _createDrawerItem(
            icon: Icons.shopping_cart,
            text: 'Pedidos',
            onTap: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushNamed(context, Routes.pedidoList);
            }),
        ListTile(
          title: const Text('0.0.1'),
          onTap: () {},
        )
      ],
    ));
  }
}
