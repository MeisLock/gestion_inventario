import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_inventario/screens/menu_screen.dart';
import 'package:gestion_inventario/widgets/dialog_cerrar_sesion.dart';
import 'package:gestion_inventario/widgets/product_card.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  double? _precioMin;
  double? _precioMax;
  String? _sistemaOperativo;
  bool? _enStock;

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
            final colorScheme = Theme.of(context).colorScheme; 

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
                  Text(
                    "Filtros",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rango de precios del producto",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface, 
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${min.toStringAsFixed(0)}", style: TextStyle(color: colorScheme.onSurface)), 
                      Text("\$${max.toStringAsFixed(0)}", style: TextStyle(color: colorScheme.onSurface)), 
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
                      border: Border.all(color: colorScheme.outline), 
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      hint: Text("Sistema Operativo", style: TextStyle(color: colorScheme.onSurface)),
                      value: sistema,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: colorScheme.surface, 
                      items: ["Android", "iOS"].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e, style: TextStyle(color: colorScheme.onSurface)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() => sistema = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline), 
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Solo disponibles", style: TextStyle(color: colorScheme.onSurface)), 
                      value: stock ?? false,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setModalState(() => stock = value);
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

  void _nuevoProducto() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text("Nuevo producto"),
        content: Text("Aquí irá el formulario"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: colorScheme.surface, 
            floating: true,
            snap: true,
            leading: 
              Padding(
                // 🔹 Añadir un Padding para poder poner margenes para centrar el Icono
                padding: const EdgeInsets.only(left: 20), 
                child: 
                IconButton(
                  onPressed: () {// 🔹 Creado un Dialog para el submenu de opciones con el switch para el cambio de tema
                    showGeneralDialog(
                      context: context,
                      barrierLabel: 'menu',
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const MenuScreenWidget();
                      },
                    );
                  },
                  icon: Icon(Icons.menu, color: colorScheme.onSurface), 
                ),
              ),  
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
                onPressed: () => mostrarDialogoCerrarSesion(context),// 🔹 Creado un Dialog para confirmar el cerrar seseión
                icon: Icon(Icons.logout, color: colorScheme.onSurface), 
              ),
              const SizedBox(width: 14,)//🔹 Modificación para centralo más
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
                      width: 350,// 🔹 Modificación al tamaño de la barra buscadora
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest, 
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar producto...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.4), 
                          ),
                          prefixIcon: Icon(Icons.search, color: colorScheme.onSurface), 
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
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _mostrarFiltros,
                          icon: Icon(Icons.filter_list, color: colorScheme.onSurface), 
                          label: Text('Filtro', style: TextStyle(color: colorScheme.onSurface)), 
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            elevation: 3,
                            backgroundColor: colorScheme.surfaceContainerHighest, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 140),// 🔹 Ajuste al centrado entre botones
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add, color: Color.fromRGBO(8, 102, 255, 1)),
                          label: Text('Nuevo', style: TextStyle(color: colorScheme.onSurface)), 
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 40),//🔹Modificación del tamaño del Icono Nuevo
                            side: BorderSide.none,
                            elevation: 3,
                            backgroundColor: colorScheme.surfaceContainerHighest, 
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
              return Center(child: Text('Error al cargar productos', style: TextStyle(color: colorScheme.onSurface))); 
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No hay productos', style: TextStyle(color: colorScheme.onSurface))); 
            }

            final productosFirebase = snapshot.data!.docs;

            final productosFiltrados = productosFirebase.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final precio = (data["precio"] ?? 0).toDouble();
              final sistema = data["sistema"] as String?;
              final stock = (data["stock"] ?? 0) as int;

              if (_precioMax != null && precio > _precioMax!) {
                return false;
              }

              if (filtroSistema != null &&
                  filtroSistema.isNotEmpty) {
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
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = productosFiltrados[index].data() as Map<String, dynamic>;
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