import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // con esto subo la imagen a la base de datos en firestore y consigo la URL
  Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('productos/$fileName.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Guardar los productos en Firestore
  Future<void> addProducto({
    required String nombre,
    required String descripcion,
    required String sistemaOperativo,
    required int stock,
    required double precio,
    required String imageUrl,
  }) async {
    await _firestore.collection('productos').add({
      'nombre': nombre,
      'descripcion': descripcion,
      'sistemaOperativo': sistemaOperativo,
      'stock': stock,
      'precio': precio,
      'imageUrl': imageUrl,
    });
  }

  // Obtenego el stream de productos para mostrarlos en tiempo real en la home screen
  Stream<QuerySnapshot> getProductos() {
    return _firestore.collection('productos').snapshots();
  }
}