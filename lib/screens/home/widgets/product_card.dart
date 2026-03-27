import 'dart:ui';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.nombre, required this.precio, required this.imageUrl});

  final String nombre;
  final double precio;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      //Imagen(Cambiar lógica al añadir Firebase)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color:  const Color.fromARGB(255, 234, 241, 253), // 🔹 El color de la imagen simepre el mismo aunque esten en modo obscuro
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(
                Icons.image_outlined,
                color:  const Color.fromARGB(255, 151, 191, 243), // 🔹 El color de la imagen simepre el mismo aunque esten en modo obscuro
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Nombre producto
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 4),
                //Precio Producto
                Text(
                  precio.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
