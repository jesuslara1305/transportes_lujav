import 'package:flutter/cupertino.dart';


const Color lujavRed = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFD32F2F),
  darkColor: Color(0xFFFF5252),
);

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return CupertinoPageScaffold(
      
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Recuperar Contraseña'),
        backgroundColor: lujavRed,
        previousPageTitle: 'Login',
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.lock_open_fill, size: 80, color: lujavRed),
                const SizedBox(height: 20),

                Text(
                  '¿Olvidaste tu clave?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                
                Text(
                  'Ingresa tu correo y te enviaremos instrucciones para restablecerla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? CupertinoColors.systemGrey4 : CupertinoColors.systemGrey,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 40),

                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  padding: const EdgeInsets.all(16),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(CupertinoIcons.mail_solid, color: CupertinoColors.systemGrey),
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
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Correo enviado'),
                          content: Text('Se han enviado instrucciones a ${_emailController.text}'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Enviar Instrucciones', style: TextStyle(fontWeight: FontWeight.bold)),
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