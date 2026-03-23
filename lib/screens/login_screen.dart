import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  // 🔹 Controladores para email y password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 Instancia de Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Método para login
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa email y contraseña'))
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login exitoso → ir a HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al iniciar sesión'))
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 40),

              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Gestor de Inventario',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 131, 131, 131),
                ),
              ),

              const SizedBox(height: 36),

              //Campo Email
              buildLabel('Correo electronico'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController, // 🔹 Conectado a Firebase
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'email@domain.com', 
                  hintStyle: const TextStyle(color: Color.fromARGB(186, 66, 70, 75), fontSize: 15),   
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //Campo Contraseña
              buildLabel('Contraseña'),
              TextField(
                controller: _passwordController, // 🔹 Conectado a Firebase
                obscureText: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Password', 
                  hintStyle: const TextStyle(color: Color.fromARGB(186, 66, 70, 75), fontSize: 15),   
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //Botón Login
              SizedBox(
                width: 350,
                height: 54,
                child: ElevatedButton(
                  onPressed: _login, // 🔹 Llama a Firebase
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.black,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ... El resto de tu diseño permanece igual ...
              const SizedBox(height: 20),
              const Text(
                '¿Has olvidado la contraseña?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF3B82F6),
                ),
              ),
              
              const SizedBox(height: 20),
 
              //Botón Google
              SizedBox(
                width: 350,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    //Añadir lógica de inicio sesión con Google
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/iconos/google_logo.png',
                        width: 22,
                        height: 22,
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'Continuar con Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
 
              const SizedBox(height: 12),
 
              //Botón Facebook 
              SizedBox(
                width: 350,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    //Añadir lógica de inicio sesión con Facebook
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(8, 102, 255, 1),
                    side: const BorderSide(color: Color.fromRGBO(8, 102, 255, 1), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/iconos/facebook_logo.png',
                        width: 40,
                        height: 40,
                      ),

                      const Text(
                        'Continuar con Facebook',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
 
              const SizedBox(height: 28),
 
              // ── ¿No tienes cuenta? ──
              const Text(
                '¿No tienes cuenta? Registrate',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}