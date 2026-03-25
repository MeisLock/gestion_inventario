import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_inventario/widgets/product_card.dart';
import '../services/firebase_service.dart';
import 'login_screen.dart';
import '../theme/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            floating: true,
            snap: true,
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            actions: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeController.themeMode,
                builder: (context, themeMode, _) {
                  return IconButton(
                    onPressed: () {
                      ThemeController.toggleTheme();
                    },
                    icon: Icon(
                      themeMode == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  );
                },
              ),

              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            title: Text(
              'Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
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
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar producto...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),

                    // Botones
                    Row(
                      children: [
                        const SizedBox(width: 15),

                        OutlinedButton.icon(
                          onPressed: () {},
                          //Icono del filtro
                          icon: Icon(
                            Icons.filter_list,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          //Texto del filtro
                          label: Text(
                            'Filtro',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            elevation: 3,
                            backgroundColor: isDark
                                ? const Color(0xFF1E1E1E)
                                : const Color.fromRGBO(247, 242, 250, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: const Size(0, 1),
                          ),
                        ),

                        const SizedBox(width: 170),

                        OutlinedButton.icon(
                          onPressed: () {},
                          //Icono del nuevo producto
                          icon: Icon(Icons.add, color: colorScheme.primary),
                          //Texto del nuevo producto
                          label: Text(
                            'Nuevo',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            elevation: 3,
                            backgroundColor: isDark
                                ? const Color(0xFF1E1E1E)
                                : const Color.fromRGBO(247, 242, 250, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
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
        body: StreamBuilder<QuerySnapshot>(
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

            return GridView.builder(
              padding: EdgeInsets.all(20),
              clipBehavior: Clip.none,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),

              itemCount: productosFirebase.length,
              itemBuilder: (context, index) {
                final producto =
                    productosFirebase[index].data() as Map<String, dynamic>;
                return ProductCard(
                  nombre: producto["nombre"] as String,
                  precio: producto["precio"] as double,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
