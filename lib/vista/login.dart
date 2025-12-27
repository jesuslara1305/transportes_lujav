import 'package:flutter/cupertino.dart';
import 'recuperar_password.dart';

const Color lujavRed = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFD32F2F),
  darkColor: Color(0xFFFF5252),
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transportes Lujav'),
        backgroundColor: lujavRed,
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.bus, size: 80, color: lujavRed),
                const SizedBox(height: 20),
                
                Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                   color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 40),

                
                CupertinoTextField(
                  controller: _userController,
                  placeholder: 'Usuario o Correo',
                  padding: const EdgeInsets.all(16),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(CupertinoIcons.person_solid, color: CupertinoColors.systemGrey),
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _passController,
                  placeholder: 'Contraseña',
                  obscureText: true,
                  padding: const EdgeInsets.all(16),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(CupertinoIcons.lock_fill, color: CupertinoColors.systemGrey),
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () {
                      print("Login: ${_userController.text}");
                    },
                    child: const Text('Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),

                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const RecuperarPasswordScreen()),
                  );
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}