import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/services/firebase/firebase_service.dart';

class HistorialMovimientosScreen extends StatelessWidget {
  HistorialMovimientosScreen({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  String _formatearFecha(Timestamp? timestamp) {
    if (timestamp == null) return 'Fecha no disponible';

    final fecha = timestamp.toDate();
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio - $hora:$minuto';
  }

  IconData _iconoPorTipo(String tipo) {
    switch (tipo) {
      case 'entrada':
        return Icons.add_circle_outline;
      case 'salida':
        return Icons.remove_circle_outline;
      case 'creacion':
        return Icons.inventory_2_outlined;
      case 'eliminacion':
        return Icons.delete_outline;
      default:
        return Icons.edit_outlined;
    }
  }

  String _tituloPorTipo(String tipo) {
    switch (tipo) {
      case 'entrada':
        return 'Entrada de stock';
      case 'salida':
        return 'Salida de stock';
      case 'creacion':
        return 'Creación de producto';
      case 'eliminacion':
        return 'Eliminación de producto';
      default:
        return 'Edición de producto';
    }
  }

  String _cantidadConSigno(int cantidad) {
    if (cantidad > 0) return '+$cantidad';
    return '$cantidad';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Historial de movimientos',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getMovimientos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar el historial'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay movimientos registrados'));
          }

          final movimientos = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: movimientos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = movimientos[index].data() as Map<String, dynamic>;

              final String tipo = (data['tipo'] ?? 'edicion').toString();
              final String nombreProducto =
                  (data['nombreProducto'] ?? 'Producto sin nombre').toString();
              final int cantidad = (data['cantidad'] as num?)?.toInt() ?? 0;
              final int stockAnterior =
                  (data['stockAnterior'] as num?)?.toInt() ?? 0;
              final int stockNuevo = (data['stockNuevo'] as num?)?.toInt() ?? 0;
              final String descripcion = (data['descripcion'] ?? '').toString();
              final Timestamp? fecha = data['fecha'] as Timestamp?;

              return Card(
                elevation: 2,
                color: colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: Icon(
                    _iconoPorTipo(tipo),
                    color: colorScheme.primary,
                    size: 30,
                  ),
                  title: Text(
                    nombreProducto,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_tituloPorTipo(tipo)),
                          const SizedBox(height: 4),
                          Text('Cantidad: ${_cantidadConSigno(cantidad)}'),
                          Text('Stock: $stockAnterior → $stockNuevo'),
                          if (descripcion.isNotEmpty) Text(descripcion),
                          const SizedBox(height: 4),
                          Text('Fecha: ${_formatearFecha(fecha)}'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
