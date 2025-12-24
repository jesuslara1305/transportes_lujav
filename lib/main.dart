import 'package:flutter/cupertino.dart';
import 'vista/login.dart';

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