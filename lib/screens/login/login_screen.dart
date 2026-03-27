import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_inventario/widgets/build_label.dart';
import '../home/home_screen.dart';
import 'screens/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  variable para controlar la visibilidad de la contraseña con bool y un IconButton en el TextField
  bool _obscurePassword = true;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa email y contraseña')),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al iniciar sesión')),
      );
    }
  }

  Future<void> _recuperarContrasena() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe tu correo para recuperar la contraseña'),
        ),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Se ha enviado un correo para restablecer la contraseña',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = 'No se pudo enviar el correo de recuperación';

      if (e.code == 'invalid-email') {
        mensaje = 'El correo no es válido';
      } else if (e.code == 'user-not-found') {
        mensaje = 'No existe ninguna cuenta con ese correo';
      } else if (e.code == 'too-many-requests') {
        mensaje = 'Demasiados intentos. Inténtalo más tarde';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Firebase: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error con Google: $e')));
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Gestor de Inventario',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              const SizedBox(height: 36),

              buildLabel('Correo electronico', colorScheme),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'email@domain.com',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              buildLabel('Contraseña', colorScheme),
              const SizedBox(height: 8),

              // Aquí añadimos el TextField para la contraseña con el IconButton para mostrar/ocultar la contraseña
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _recuperarContrasena,
                  child: const Text(
                    '¿Has olvidado la contraseña?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 350,
                height: 54,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.onSurface,
                    foregroundColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.withValues(alpha: .5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'o continue con',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.withValues(alpha: .5)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 350,
                height: 54,
                child: OutlinedButton(
                  onPressed: _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    side: BorderSide(color: colorScheme.outline, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                      Text(
                        'Continuar con Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
