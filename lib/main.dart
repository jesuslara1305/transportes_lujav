import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'vista/login.dart';


const Color lujavRed = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFD32F2F),
  darkColor: Color(0xFFFF5252),
);

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDRvBhsZvdcWf8yIzfsoP4cFNXhghNHnIc", 
        appId: "1071723812052:web:b8194b5c8f4018adc65741", 
        messagingSenderId: "1071723812052",
        projectId: "plataforma-5ef7d",
        storageBucket: "plataforma-5ef7d.firebasestorage.app",
      ),
    );
    print("Firebase conectado correctamente jiji");
  } catch (e) {
    print("Error al conectar Firebase: $e");
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: lujavRed,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}