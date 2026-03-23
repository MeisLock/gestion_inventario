import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_inventario/widgets/product_card.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle))
          ],
          title: const Text('Menu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
              
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
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
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                    

                  // Botones
                  Row(children: [
                      const SizedBox(width: 15),

                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list, color: Color.fromARGB(255, 98, 98, 98)),
                        label: const Text('Filtro'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          elevation: 3,
                          backgroundColor: const Color.fromRGBO(247, 242, 250, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 1),
                        ),
                      ),

                      const SizedBox(width: 170),

                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Color.fromRGBO(8, 102, 255, 1)),
                        label: const Text('Nuevo'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          elevation: 3,
                          backgroundColor: const Color.fromRGBO(247, 242, 250, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],

    

            //🔹 Lista de productos desde Firebase
  body: 
    StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getProductos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar productos'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay productos'));
        }
                    
        final productosFirebase = snapshot.data!.docs;

        return 
          GridView.builder(
            padding: EdgeInsets.all(20),
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            ), 

            itemCount: productosFirebase.length,  
            itemBuilder: (context, index){
            final producto = productosFirebase[index].data() as Map<String, dynamic>;
            return ProductCard(
            nombre: producto["nombre"] as String,
            precio: producto["precio"] as double,
            );
          }
        );
      },
    ),
  )
);
}
}