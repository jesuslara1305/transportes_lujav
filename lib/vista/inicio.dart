import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; 

class Inicio extends StatefulWidget {
  final String nombreUsuario;

  const Inicio({super.key, required this.nombreUsuario});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  
  final CupertinoTabController _controller = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _controller, 
      tabBar: CupertinoTabBar(
        
        onTap: (index) {
          if (index == 1) {
            
            
            _mostrarAlertaSalida(context);
          } else {
            
            _controller.index = index;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_arrow_right),
            label: 'Salir',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        
        
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Mi App'),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.person_circle, size: 100, color: CupertinoColors.activeBlue),
                const SizedBox(height: 20),
                Text(
                  "Bienvenido:",
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.nombreUsuario, 
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  void _mostrarAlertaSalida(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("¿Cerrar sesión?"),
          content: const Text("¿Estás seguro de que deseas salir del sistema?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Salir"),
              onPressed: () async {
                Navigator.pop(context); 
                await FirebaseAuth.instance.signOut(); 
                
                if (mounted) {
                  
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}