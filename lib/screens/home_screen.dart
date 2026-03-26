import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_inventario/screens/add_screen.dart';
import 'package:gestion_inventario/screens/menu_screen.dart';
import 'package:gestion_inventario/widgets/dialog_confirmacion.dart';
import 'package:gestion_inventario/widgets/dialog_cerrar_sesion.dart';
import 'package:gestion_inventario/widgets/product_card.dart';
import '../services/firebase_service.dart';
// 🔹 Removemos los imports que no se usan

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController _searchController = TextEditingController();
  String _busqueda = "";

  double? _precioMin;
  double? _precioMax;
  String? _sistemaOperativo;
  bool? _enStock;

  // Función para mostrar el modal de filtros
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Filtros",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Rango de precios del producto",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      items: ["Android", "IOS"].map((e) {
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
      // 🔹 Movemos el ListView a la pantalla de menu_screen
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            floating: true,
            snap: true,
            leading: Padding(
              // 🔹 Añadir un Padding para poder poner margenes para centrar el Icono
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: () {
                  showGeneralDialog(
                    // 🔹 Creado un Dialog para el submenu de opciones
                    context: context,
                    barrierLabel: 'menu',
                    barrierDismissible: true,
                    barrierColor: Colors.transparent,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const MenuScreenWidget();
                    },
                  );
                },
                icon: const Icon(Icons.menu),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => mostrarDialogoCerrarSesion(
                  context,
                ), // 🔹 Agregamos el metodo para el AlertDialog para cerrar sesión
                icon: const Icon(Icons.logout),
              ),
              const SizedBox(width: 14), //🔹 Modificación para centrarlo más
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
                      width: 350,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _busqueda = value.toLowerCase();
                          });
                        },
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
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _busqueda = "";
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        OutlinedButton.icon(
                          onPressed: _mostrarFiltros,
                          icon: Icon(
                            Icons.filter_list,
                            color: colorScheme.onSurfaceVariant,
                          ),
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
                        const SizedBox(width: 140),
                        OutlinedButton.icon(
                          onPressed: () => mostrarDialogoConfirmacion(
                            context,
                            titulo: 'Añadir Producto',
                            mensaje: '¿Quieres añadir un producto?',
                            onAceptar: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => AddScreen()),
                              );
                            },
                          ),
                          icon: Icon(Icons.add, color: colorScheme.primary),
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

            final productosFiltrados = productosFirebase.where((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final nombre = (data["nombre"] ?? "").toString().toLowerCase();
              final precio = (data["precio"] ?? 0).toDouble();
              final stock = (data["stock"] ?? 0) as int;

              final sistema =
                  ((data["sistema"] ??
                              data["sistemaOperativo"] ??
                              data["SO"] ??
                              "")
                          .toString())
                      .trim()
                      .toUpperCase();
              final filtroSistema = _sistemaOperativo?.trim().toUpperCase();

              if (_busqueda.isNotEmpty && !nombre.contains(_busqueda)) {
                return false;
              }

              if (_precioMin != null && precio < _precioMin!) {
                return false;
              }

              if (_precioMax != null && precio > _precioMax!) {
                return false;
              }

              if (filtroSistema != null && filtroSistema.isNotEmpty) {
                if (sistema != filtroSistema) {
                  return false;
                }
              }

              if (_enStock == true && stock <= 0) {
                return false;
              }

              return true;
            }).toList();

            return GridView.builder(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 8, // 🔹 Elimina el espacio superior entre los dos bodies
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto =
                    productosFiltrados[index].data() as Map<String, dynamic>;

                return ProductCard(
                  nombre: producto["nombre"] as String,
                  precio: (producto["precio"] ?? 0).toDouble(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
