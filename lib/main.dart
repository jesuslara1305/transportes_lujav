import 'package:flutter/cupertino.dart';
import 'vista/login.dart';


const Color lujavRed = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFD32F2F),
  darkColor: Color(0xFFFF5252),
);

void main() {
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