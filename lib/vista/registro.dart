import 'package:flutter/cupertino.dart';
import '../control/Access.dart';


const Color lujavRed = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFD32F2F),
  darkColor: Color(0xFFFF5252),
);

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final Access _authController = Access();
  bool valido = false;
  bool _obscureText = true;
  bool _isLoading = false;

  void _handleRegistro() async {
    if(_nameController.text.isEmpty) {
      _mostrarAlerta("Debes llenar el campo de nombre");
      return;
    }
    if(_emailController.text.isEmpty) {
      _mostrarAlerta("Debes llenar el campo de correo electrónico");
      return;
    }
    if(_passController.text.isEmpty) {
      _mostrarAlerta("Debes llenar el campo de contraseña");
      return;
    }

    setState(() => _isLoading = true);
    String? error = await _authController.registrarUsuario(
      email: _emailController.text,
      password: _passController.text,
      nombre: _nameController.text,
    );

    setState(() => _isLoading = false);

    if (error == null) {
      if(mounted) {
        valido = true;
        _mostrarAlerta("La cuenta se ha creado, revisa tu bandeja de entrada o spam para verificar tus datos de inicio de sesión");
        _nameController.clear();
        _emailController.clear();
        _passController.clear();
      }
    } else {
      _mostrarAlerta(error);
    }
  }

  void _mostrarAlerta(String mensaje) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(valido ? "Éxito" : "Error"),
        content: Text(mensaje),
        actions: [CupertinoDialogAction(child: const Text("OK"), onPressed: () => Navigator.pop(ctx))]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color textColor = isDarkMode ? CupertinoColors.white : CupertinoColors.black;
    final Color secondaryTextColor = isDarkMode ? CupertinoColors.systemGrey4 : CupertinoColors.systemGrey;
    final Color inputBgColor = CupertinoColors.secondarySystemGroupedBackground;
    final Color mainBtnColor = isDarkMode ? CupertinoColors.white : CupertinoColors.black;
    final Color mainBtnTextColor = isDarkMode ? CupertinoColors.black : CupertinoColors.white;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(CupertinoIcons.bus, size: 60, color: lujavRed),
                const SizedBox(height: 10),
                Text(
                  'Transportes Lujav',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: lujavRed,
                    decoration: TextDecoration.none,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Transformamos la logística en eficiencia. Regístrate para comenzar a gestionar tus rutas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.4,
                    decoration: TextDecoration.none,
                  ),
                ),
                
                const SizedBox(height: 40),
                Text(
                  'Crear cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Ingresa tus datos para registrarte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 30),
                _buildLabel('Nombre Completo', textColor),
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Ej. Juan Pérez',
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Icon(CupertinoIcons.person, color: secondaryTextColor, size: 20),
                  ),
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Correo Electrónico', textColor),
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'ejemplo@transporteslujav.com',
                  keyboardType: TextInputType.emailAddress,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Icon(CupertinoIcons.mail, color: secondaryTextColor, size: 20),
                  ),
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Contraseña', textColor),
                CupertinoTextField(
                  controller: _passController,
                  placeholder: '••••••••',
                  obscureText: _obscureText,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Icon(CupertinoIcons.lock, color: secondaryTextColor, size: 20),
                  ),
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.only(right: 12),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                    child: Icon(
                      _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                      color: secondaryTextColor,
                      size: 20,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: mainBtnColor,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: _isLoading ? null : _handleRegistro,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Registrarse', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: mainBtnTextColor
                          )
                        ),
                        const SizedBox(width: 8),
                        Icon(CupertinoIcons.arrow_right, size: 18, color: mainBtnTextColor)
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                
                
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: CupertinoColors.systemGrey5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O CONTINUAR CON',
                        style: TextStyle(fontSize: 11, color: secondaryTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: CupertinoColors.systemGrey5)),
                  ],
                ),

                const SizedBox(height: 20),

                
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: inputBgColor,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () async {
                    Access _authController = Access();
                    String? error = await _authController.registroGoogle(esRegistro: true);

                    if (error == null) {
                      if (mounted) {
                        await showCupertinoDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text("¡Bienvenido!"),
                              content: const Text("Tu cuenta con Google se creó exitosamente"),
                              actions: [
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: const Text("Aceptar"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } 
                    else if (error == "YA_EXISTE") {
                    if (mounted) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text("Cuenta existente"),
                          content: const Text("Este correo de Google ya está registrado en el sistema. Por favor, inicia sesión."),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("Aceptar"),
                              onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                            )
                          ],
                        ),
                      );
                    }
                  }
                    else {
                      if (error != "Cancelado por el usuario") {
                        _mostrarAlerta(error);
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'multimedia/google.png', 
                        height: 24, 
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Google',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes una cuenta? ', style: TextStyle(color: secondaryTextColor, fontSize: 14)),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      
                      onPressed: () => Navigator.pop(context), minimumSize: Size(0, 0),
                      child: Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}