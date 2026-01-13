import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lujav/vista/inicio.dart';
import 'recuperar_password.dart';
import 'registro.dart';
import '../control/Access.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final Access _authController = Access();
  
  bool _obscureText = true;
  bool _rememberMe = false;
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarCredenciales(); 
  }

  Future<void> _cargarCredenciales() async {
    String? email = await _storage.read(key: 'key_email');
    String? password = await _storage.read(key: 'key_pass');
    if (email != null && password != null) {
      setState(() {
        _userController.text = email;
        _passController.text = password;
        _rememberMe = true;
      });
    }
  }

  Future<void> _guardarUOlvidar() async {
    if (_rememberMe) {
      await _storage.write(key: 'key_email', value: _userController.text);
      await _storage.write(key: 'key_pass', value: _passController.text);
    } else {
      await _storage.delete(key: 'key_email');
      await _storage.delete(key: 'key_pass');
    }
  }

  void _handleLogin() async {
    if(_userController.text.isEmpty) {
      _mostrarAlerta("Debes llenar el campo de correo electrónico");
      return;
    }
    if(_passController.text.isEmpty) {
      _mostrarAlerta("Debes llenar el campo de contraseña");
      return;
    }
  await _guardarUOlvidar();
    setState(() => _isLoading = true);

    String? error = await _authController.iniciarSesion(
      _userController.text, 
      _passController.text
    );

    setState(() => _isLoading = false);

    if (error == null) {
      final user = FirebaseAuth.instance.currentUser;
      String nombreEnviar = user?.displayName ?? user?.email ?? "Usuario";

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => Inicio(nombreUsuario: nombreEnviar),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      _mostrarAlerta(error);
    }
  }

  void _mostrarAlerta(String mensaje) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text("Error"),
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
                  'Transformamos la logística en eficiencia. Accede a tu panel de control para gestionar rutas, cotizaciones y servicios de transporte.',
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
                  'Bienvenido de nuevo',
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
                  'Ingresa tus credenciales para acceder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 30),
                _buildLabel('Correo Electrónico', textColor),
                CupertinoTextField(
                  controller: _userController,
                  placeholder: 'ejemplo@transporteslujav.com',
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
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        children: [
                          Icon(
                            
                            _rememberMe ? CupertinoIcons.checkmark_square_fill : CupertinoIcons.square,
                            color: _rememberMe ? lujavRed : CupertinoColors.systemGrey,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recordarme',
                            style: TextStyle(fontSize: 13, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    
                    
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => const RecuperarPasswordScreen()),
                        );
                      }, minimumSize: Size(0, 0),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.w600,
                          color: lujavRed 
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: mainBtnColor,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Iniciar Sesión', 
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
                  String? error = await _authController.registroGoogle();

                  if (error == null) {
                    final user = FirebaseAuth.instance.currentUser;
                    String nombreEnviar = user?.displayName ?? user?.email ?? "Usuario";

                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Inicio(nombreUsuario: nombreEnviar),
                        ),
                        (route) => false, 
                      );
                    }
                  } else {
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
                    Text('¿No tienes una cuenta? ', style: TextStyle(color: secondaryTextColor, fontSize: 14)),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const RegistroScreen()),
                      );
                    }, minimumSize: Size(0, 0),
                      child: Text(
                        'Regístrate ahora',
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