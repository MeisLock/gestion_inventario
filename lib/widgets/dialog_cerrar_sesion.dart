import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/screens/login_screen.dart';

//Dialog para confirmar el cierre de sesión

Future<void> mostrarDialogoCerrarSesion(BuildContext context) async{
  final eleccion = await showDialog<bool>(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('Cerrar Sesión'),
      content: const Text('¿Estás seguro de cerrar sesión?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
  if(eleccion == true){
    await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
  }    
}