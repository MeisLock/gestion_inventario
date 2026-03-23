import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(nombre),
        subtitle: Text(descripcion),
        trailing: Text("${precio}€"),
      ),
    );
  }
}