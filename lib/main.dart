import 'package:flutter/material.dart';
import 'package:gestion_inventario/screens/login_screen.dart';//Quitar import de la Home debería de estar en LoginScreen

void main() {

  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
      );
  }
}