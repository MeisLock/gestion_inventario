import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_inventario/services/firebase/firebase_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gestion_inventario/services/select_image.dart';
import 'package:gestion_inventario/services/firebase/upload_image.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _precioController;
  late final TextEditingController _stockController;
  File? imagenToEdit;

  String? _sistemaOperativo;
  bool _guardando = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.productData['nombre']?.toString() ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.productData['descripcion']?.toString() ?? '',
    );
    _precioController = TextEditingController(
      text: widget.productData['precio']?.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.productData['stock']?.toString() ?? '',
    );

    _sistemaOperativo = widget.productData['sistemaOperativo']?.toString();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _actualizarProducto() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final precio = double.tryParse(_precioController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());
    if (imagenToEdit != null)  await uploadImage(imagenToEdit!);

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        precio == null ||
        stock == null ||
        _sistemaOperativo == null ||
        _sistemaOperativo!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos correctamente'),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Productos')
          .doc(widget.productId)
          .update({
            'nombre': nombre,
            'descripcion': descripcion,
            'precio': precio,
            'stock': stock,
            'sistemaOperativo': _sistemaOperativo,
            if (imagenToEdit != null) 'imageUrl':imageUrl
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado correctamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el producto: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value:
                  (_sistemaOperativo == 'Android' || _sistemaOperativo == 'IOS')
                  ? _sistemaOperativo
                  : null,
              decoration: const InputDecoration(
                labelText: 'Sistema operativo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Android', child: Text('Android')),
                DropdownMenuItem(value: 'IOS', child: Text('IOS')),
              ],
              onChanged: (value) {
                setState(() {
                  _sistemaOperativo = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _precioController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
                    SizedBox(
                      height: 150, // 🔹 Altura fija en vez de Expanded
                      width: double.infinity,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [8, 2],
                        color: colorScheme.onSurface,
                        strokeWidth: 1.5,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,  
                          children: [
                              imagenToEdit != null ? Image.file(imagenToEdit!) :
                              OutlinedButton.icon(
                                onPressed:() async{
                                  final imagen =await getImage();
                                  if(imagen == null) return;
                                  setState(() {
                                    imagenToEdit = File(imagen.path);
                                  });
                                }, 
                                label: Text('Imagen'),
                                icon: Icon(Icons.add_a_photo_outlined),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _guardando ? null : _actualizarProducto,
                child: _guardando
                    ? const CircularProgressIndicator()
                    : const Text('Guardar cambios'),
                    
              ),
            ),
          ],
        ),
      ),
    );
  }
}
