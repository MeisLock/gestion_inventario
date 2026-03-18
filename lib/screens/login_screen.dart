import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Gestor de Inventario \n         Bienvenido '), 
            centerTitle: true,
        ),
        body:
            //Center
            Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('Inicio de sesión', style: const TextStyle( fontSize: 40, fontWeight: FontWeight.bold),),

                    const SizedBox(height: 50),

                    Text('Correo Electronico', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w200),),

                    TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: 'Hola que tal',
                            hintText: 'ejemplo@email.com',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.2)),
                        ),
                    ),

                    const SizedBox(height: 50),

                    Text('Contraseña', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),

                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'Contraseña',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(),
                        ),
                    ),

                    const SizedBox(height: 300),
                    
                ],//Acaba el hijo
            ),
        ) ,
    );
  }
}