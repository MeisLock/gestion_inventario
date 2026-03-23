import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {

  const ProductCard({
    super.key, 
    required this.nombre, 
    required this.precio,
    });

    final String nombre;
    final double precio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: Offset(0, 3)
          )
        ]
      ),
      //Imagen(Cambiar lógica al añadir Firebase)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 220, 234, 245),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12)
                  )
              ),
              child: Icon(
                Icons.image_outlined,
                color: Color.fromARGB(255, 147, 197, 216),
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
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                  )
                ),

                const SizedBox(height: 4,),
                //Precio Producto
                Text(
                  precio.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
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