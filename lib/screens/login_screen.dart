import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
       @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
 
              const SizedBox(height: 40),
 
              // ── Título ──
              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
 
              const SizedBox(height: 4),
 
              const Text(
                'Gestor de Inventario',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
 
              const SizedBox(height: 36),
 
              // ── Campo Email ──
              buildLabel('Correo electronico'),
              const SizedBox(height: 8),
              TextField(
                textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'email@domain.com', 
                    hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 15),   
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
 
              const SizedBox(height: 16),
 
              // ── Campo Contraseña ──
              buildLabel('Contraseña'),
              TextField(
                textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Password', 
                    hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontSize: 15),   
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
 
              // ── Botón Login ──
              SizedBox(
                width: 350,
                height: 54,
                child: ElevatedButton(
                  onPressed:() {
                    
                  }, // TODO: añade tu lógica de login
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
 
              const SizedBox(height: 20),
 
              // ── ¿Olvidaste contraseña? ──
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
 
              const SizedBox(height: 28),
 
              // ── Divider "o continue con" ──
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                  SizedBox(width: 12),
                  Text(
                    'o continue con',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                ],
              ),
 
              const SizedBox(height: 20),
 
              // ── Botón Google ──
              SizedBox(
                width: 350,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    
                  }, // TODO: añade tu lógica de Google
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    side: const BorderSide(
                        color: Color(0xFFD1D5DB), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CustomPaint(),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Continuar con Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
 
              const SizedBox(height: 12),
 
              // ── Botón Facebook ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:() {
                    
                  }, // TODO: añade tu lógica de Facebook
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    disabledBackgroundColor: const Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'f',//Cambiar logo Facebook ver como se puede poner imagen
                            style: TextStyle(
                              color: Color(0xFF1877F2),
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Continue con Facebook',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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
 
              const SizedBox(height: 40),
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
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}


 