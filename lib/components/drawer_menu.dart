import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  void _handleConfirmarSaida() async {
    final sair = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar saída'),
          content: const Text('Tem certeza que deseja sair do app agora?'),
          actions: [
            TextButton(
              child: const Text("NÃO"),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("SIM"),
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
    if (sair) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        Widget drawerHeader = const Center(
          child: CircularProgressIndicator(),
        );
        User? _user = FirebaseAuth.instance.currentUser;
        if (snapshot.hasData) {
          drawerHeader = DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Column(
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    radius: 48,
                    child: _user?.photoURL != null
                        ? ClipOval(
                            child: Material(
                              child: Image.network(
                                _user?.photoURL ?? '',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          )
                        : const ClipOval(
                            child: Material(
                              color: Colors.grey,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Text(
                  _user?.displayName ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        }
        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              drawerHeader,
              ListTile(
                title: const Text('Meus veículos'),
                leading: const Icon(Icons.car_rental),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Postos de combustível'),
                leading: const Icon(Icons.business),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Expanded(child: Container()),
              const Divider(),
              ListTile(
                title: const Text('Sair'),
                leading: const Icon(Icons.exit_to_app),
                onTap: _handleConfirmarSaida,
              ),
            ],
          ),
        );
      },
    );
  }
}
