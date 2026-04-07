import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.nombre,
    required this.precio,
    required this.imageUrl,
    required this.descripcion, // 👈 nuevo
    required this.stock,       // 👈 nuevo
  });

  final String nombre;
  final double precio;
  final String imageUrl;
  final String descripcion;
  final int stock;

  void _mostrarDetalle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Center(
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 241, 253),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty && imageUrl != 'no url'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imageUrl, fit: BoxFit.contain),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: Color.fromARGB(255, 151, 191, 243),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre
            Text(
              nombre,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Precio
            Text(
              '${precio.toStringAsFixed(2)} €',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Descripción
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Stock
            Row(
              children: [
                Icon(
                  stock > 0 ? Icons.check_circle : Icons.cancel,
                  color: stock > 0 ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  stock > 0 ? 'En stock ($stock uds.)' : 'Sin stock',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: stock > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector( // 👈 Detecta el tap en toda la card
      onTap: () => _mostrarDetalle(context),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: 350,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 234, 241, 253),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: imageUrl.isNotEmpty && imageUrl != 'no url'
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(imageUrl, fit: BoxFit.contain),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        color: Color.fromARGB(255, 151, 191, 243),
                        size: 40,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${precio.toStringAsFixed(2)} €',
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
      ),
    );
  }
}