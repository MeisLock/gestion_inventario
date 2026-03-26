import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_inventario/services/firebase_service.dart';

//  Cambios para que los colores de los textos cambien segun el tema de aplicación

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();

  // Los ojos para mostrar/ocultar la contraseña en ambos TextField
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _fechaNacimiento;

  Future<void> _seleccionarFechaNacimiento() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimiento = fechaSeleccionada;
        _fechaNacimientoController.text = _formatearFecha(fechaSeleccionada);
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    return '$dia/$mes/$anio';
  }

  Future<void> _register() async {
    final String nombre = _nombreController.text.trim();
    final String apellidos = _apellidosController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (nombre.isEmpty ||
        apellidos.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
        ),
      );
      return;
    }

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName('$nombre $apellidos');

      await _firebaseService.guardarUsuario(
        uid: userCredential.user!.uid,
        nombre: nombre,
        apellidos: apellidos,
        email: email,
        fechaNacimiento: _fechaNacimiento!,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado correctamente')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al registrar usuario';

      if (e.code == 'email-already-in-use') {
        mensaje = 'Ese correo ya está en uso';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo no es válido';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es demasiado débil';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _fechaNacimientoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //  Adaptado al colorScheme del tema
  Widget _buildLabel(String text, ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text('Registro', style: TextStyle(color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              _buildLabel('Nombre', colorScheme),
              const SizedBox(height: 8),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  hintText: 'Introduce tu nombre',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel('Apellidos', colorScheme),
              const SizedBox(height: 8),
              TextField(
                controller: _apellidosController,
                decoration: InputDecoration(
                  hintText: 'Introduce tus apellidos',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel('Fecha de nacimiento', colorScheme),
              const SizedBox(height: 8),
              TextField(
                controller: _fechaNacimientoController,
                readOnly: true,
                onTap: _seleccionarFechaNacimiento,
                decoration: InputDecoration(
                  hintText: 'Selecciona tu fecha de nacimiento',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _seleccionarFechaNacimiento,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Correo electrónico', colorScheme),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'email@domain.com',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel('Contraseña', colorScheme),
              const SizedBox(height: 8),

              //
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildLabel('Confirmar contraseña', colorScheme),
              const SizedBox(height: 8),

              // TextField para confirmar contraseña con el mismo estilo y el IconButton para mostrar/ocultar la contraseña
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Repite la contraseña',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface,
                      width: 1.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.9,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 350,
                height: 54,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
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
