import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_inventario/screens/home_screen.dart';
import 'package:gestion_inventario/services/firebase_service.dart';
import 'package:gestion_inventario/services/select_image.dart';
import 'package:gestion_inventario/services/upload_image.dart';
import 'package:gestion_inventario/widgets/build_label.dart';
import 'package:gestion_inventario/widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget{
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>{
  String? _sistemaOperativo;
  int _stock = 0;
  File? imagenToUpload;

//Servicio con Firebase
  final FirebaseService _firebaseService = FirebaseService();

//Leer campos de texto que ha escrito el usuario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  bool _isLoading = false;

//Eliminacion de recursos 
  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

Future<void> _saveProduct() async {
  final nombre = _nombreController.text.trim();
  final descripcion = _descripcionController.text.trim();
  final precioTexto = _precioController.text.trim();
  
            

  // Validación básica
  if (nombre.isEmpty || descripcion.isEmpty || precioTexto.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Completa todos los campos'),
      ),
    );
    return;
  }

  if (_sistemaOperativo == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selecciona un sistema operativo'),
      ),
    );
    return;
  }

  final precio = double.tryParse(precioTexto);
  if (precio == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Precio inválido'),
      ),
    );
    return;
  }
   if (imagenToUpload == null){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('añade una imagen'),
      ),
    );
    return;
  }
   await uploadImage(imagenToUpload!); //sube la imagen a firestorage


  // Confirmación
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Añadir producto'),
        content: const Text('¿Quieres añadir este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Añadir'),
          ),
        ],
      );
    },
  );

  if (confirmar != true) return;

  setState(() {
    _isLoading = true;
  });

  try {
    await _firebaseService.addProduct(
      nombre: nombre,
      descripcion: descripcion,
      sistemaOperativo: _sistemaOperativo!,
      stock: _stock,
      precio: precio,
      imageUrl: imageUrl,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto añadido correctamente'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20,),
          child: IconButton(
            onPressed: () { 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()) 
                );
            }, 
            icon: Icon(Icons.navigate_before),
          ),
        ),
        title: Text('Añadir un producto', style: TextStyle(
          color: colorScheme.onSurface,
          ),
        
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:() {
              
            }, 
            icon:   Icon(Icons.account_circle_outlined)
          ),
          const SizedBox(width: 14,)
        ],  
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveProduct,
          icon: Icon(Icons.check, color: colorScheme.onPrimary),
          label: Text(
            'Añadir',
            style: TextStyle(color: colorScheme.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 5],
              color: Colors.grey,
              strokeWidth: 1.5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: 
                Column(
                  children: [
                    buildLabel('Nombre del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Nombre del producto',
                      controller: _nombreController,
                    ),
                    const SectionDivider(),
                    buildLabel('Descripción del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Descripción', 
                      maxLines: 4,
                      controller: _descripcionController,
                    ),
                    const SectionDivider(),
                    buildLabel('Sistema Operativo', colorScheme),
                    const SizedBox(height: 8),
                    RadioGroup<String>(
                      groupValue: _sistemaOperativo,
                      onChanged: (value) {
                        setState(() {
                          _sistemaOperativo = value;
                        });
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('IOS'),
                            value: 'IOS',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: _sistemaOperativo == 'IOS'
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                          ),
                          const SizedBox(height: 8),
                          RadioListTile<String>(
                            title: const Text('Android'),
                            value: 'Android',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: _sistemaOperativo == 'Android'
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    Row(
                      children: [
                        buildLabel('Cantidad de Stock', colorScheme),
                        Spacer(),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                if (_stock > 0) _stock--;
                              });
                            },
                            icon: Icon(Icons.remove, color: colorScheme.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$_stock',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                _stock++;
                              });
                            },
                            icon: Icon(Icons.add, color: colorScheme.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SectionDivider(),
                    buildLabel('Precio del producto', colorScheme),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Precio',
                      controller: _precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: const Icon(Icons.euro_symbol),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
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
                              imagenToUpload != null ? Image.file(imagenToUpload!) :
                              OutlinedButton.icon(
                                onPressed:() async{
                                  final imagen =await getImage();
                                  if(imagen == null) return;
                                  setState(() {
                                    imagenToUpload = File(imagen.path);
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
                  ],
                ),
              ) 
            )
          ),
        ),
      )
    );
  }
}
// 🔹 Widget perosnalizado para los separadores
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Divider(color: Colors.grey.withValues(alpha: .5)),
        const SizedBox(height: 12),
      ],
    );
  }
}