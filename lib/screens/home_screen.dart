import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  // 🔹 Instanciamos el servicio de Firebase
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // Lógica del Botón Menu
          }, 
          icon: const Icon(Icons.menu, color: Colors.black,)
        ),
        actions: [
          IconButton(
            onPressed: () { }, 
            icon: const Icon(Icons.account_circle),
          )
        ],
        title: const Text(
          'Menu', 
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w400, 
            color: Colors.black
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra buscadora
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  hintStyle: TextStyle(color: Color.fromARGB(181, 0, 0, 0)),
                  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),

            const SizedBox(height: 10,),

            // Botón Filtro + Botón Nuevo
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Lógica botón filtro
                  },
                  icon: const Icon(Icons.filter_list, color: Color(0xFF626262),),
                  label: const Text('Filtro', style: TextStyle(color: Color.fromARGB(225, 0, 0, 0)),),
                ),
                const SizedBox(width: 160,),
                OutlinedButton.icon(
                  onPressed: () {
                    // Lógica botón Nuevo
                  }, 
                  label: const Text('Nuevo', style: TextStyle(color: Color.fromARGB(225, 0, 0, 0)),),
                  icon: const Icon(Icons.add, color: Color.fromRGBO(8, 102, 255, 1)),
                )
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Lista de productos desde Firebase
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar productos'));
                }

                final productos = snapshot.data!.docs;

                if (productos.isEmpty) {
                  return const Center(child: Text('No hay productos'));
                }

                return Column(
                  children: productos.map((prod) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: prod['imageUrl'] != null && prod['imageUrl'] != ''
                            ? Image.network(
                                prod['imageUrl'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                        title: Text(prod['nombre'] ?? ''),
                        subtitle: Text(prod['descripcion'] ?? ''),
                        trailing: Text("${prod['precio'] ?? 0}€"),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}