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

  // 🔹 Variables para filtros
  double? _precioMin;
  double? _precioMax;
  String? _sistemaOperativo;
  bool? _enStock;

  // 🔹 Modal de filtros
  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double min = _precioMin ?? 0;
        double max = _precioMax ?? 2000;
        String? sistema = _sistemaOperativo;
        bool? stock = _enStock;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch, // 🔹 CAMBIO: ancho consistente
                children: [
                  const Text(
                    "Filtros",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // 🔹 RANGO DE PRECIO con descripción y valores
                  const Text(
                    "Rango de precios del producto", // 🔹 CAMBIO
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🔹 CAMBIO
                    children: [
                      Text("\$${min.toStringAsFixed(0)}"),
                      Text("\$${max.toStringAsFixed(0)}"),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(min, max),
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    labels: RangeLabels(
                      min.toStringAsFixed(0),
                      max.toStringAsFixed(0),
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        min = values.start;
                        max = values.end;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Sistema Operativo centrado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text("Sistema Operativo"),
                      value: sistema,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: ["Android", "iOS"].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          sistema = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Stock alineado al ancho
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Solo disponibles"),
                      value: stock ?? false,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setModalState(() {
                          stock = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _precioMin = min;
                        _precioMax = max;
                        _sistemaOperativo = sistema;
                        _enStock = stock;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Aplicar filtros"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                        ),
                      ),
                    ),
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

            // 🔹 FILTROS APLICADOS CON CONTROL DE NULLS
            final productosFiltrados = productosFirebase.where((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final precio = (data["precio"] ?? 0).toDouble(); // 🔹 CAMBIO
              final sistema = data["sistema"] as String?;        // 🔹 CAMBIO
              final stock = (data["stock"] ?? 0) as int;        // 🔹 CAMBIO

              if (_precioMin != null && precio < _precioMin!) return false;
              if (_precioMax != null && precio > _precioMax!) return false;
              if (_sistemaOperativo != null && sistema != _sistemaOperativo) return false;
              if (_enStock == true && stock <= 0) return false;

              return true;
            }).toList();

            return GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: productosFiltrados.length, // 🔹 CAMBIO
              itemBuilder: (context, index) {
                final producto =
                    productosFiltrados[index].data() as Map<String, dynamic>; // 🔹 CAMBIO
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
